# Day 65 - Instafilter - project 13 part 4

---

## 1. Building the Basic UI

**Goal:** Build the basic interface, just enough to see how the pieces fit. The final UI has:
1. A `NavigationStack` showing the app name at the top
2. A box prompting the user to pick a photo (their imported image displays over it)
3. An "Intensity" slider controlling how strongly Core Image filters apply (0.0–1.0)
4. A share button to export the processed image

### State properties (`ContentView`)

```swift
@State private var processedImage: Image?
@State private var filterIntensity = 0.5
```

`processedImage` is optional because the user starts with no image selected.

### Layout (`body`)

```swift
NavigationStack {
    VStack {
        Spacer()

        // image area

        Spacer()

        HStack {
            Text("Intensity")
            Slider(value: $filterIntensity)
        }
        .padding(.vertical)

        HStack {
            Button("Change Filter", action: changeFilter)

            Spacer()

            // share the picture
        }
    }
    .padding([.horizontal, .bottom])
    .navigationTitle("Instafilter")
}
```

- The two `Spacer`s guarantee space above and below the image area and keep the controls pinned to the bottom of the screen.

### Image area

```swift
if let processedImage {
    processedImage
        .resizable()
        .scaledToFit()
} else {
    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
}
```

- Optional views can sit directly in a SwiftUI layout.
- Works well with `ContentUnavailableView` since only one is visible at a time, and it makes clear the blank space is intentional.

### Cleanup tip: move button actions out of `body`

```swift
func changeFilter() {
}

Button("Change Filter", action: changeFilter)
```

- Inline actions are common while learning, but on real projects, keeping `body` clean pays off long term.

---

## 2. Importing an Image with `PhotosPicker`

Core Image doesn't work directly with SwiftUI images, so the flow is a little roundabout.

### Setup

- `import PhotosUI` at the top of `ContentView`
- Add a state property to track the selection:

```swift
@State private var selectedItem: PhotosPickerItem?
```

### Add the picker

Wrap the whole `if let processedImage` check so the image or placeholder acts as the picker's label:

```swift
PhotosPicker(selection: $selectedItem) {
    if let processedImage {
        processedImage
            .resizable()
            .scaledToFit()
    } else {
        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
    }
}
```

> **Tip:** The placeholder gets blue coloring to show it's interactive. Add `.buttonStyle(.plain)` to the `PhotosPicker` to remove it.

### Load the selected image

A SwiftUI `Image` can't be fed into Core Image, so load raw `Data` and convert it to a `UIImage`:

```swift
func loadImage() {
    Task {
        guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
        guard let inputImage = UIImage(data: imageData) else { return }

        // more code to come (see section 3)
    }
}
```

### Trigger loading when the selection changes

```swift
.onChange(of: selectedItem, loadImage)
```

- Can go anywhere in `ContentView`, but attaching it to the `PhotosPicker` makes sense.
- At this point the photo picker opens, but nothing happens with the selection yet.

---

## 3. Basic Image Filtering with Core Image

Start with a single filter (sepia tone); later it gets extended with a confirmation dialog.

### Imports

```swift
import CoreImage
import CoreImage.CIFilterBuiltins
```

### Filter and context

```swift
@State private var currentFilter = CIFilter.sepiaTone()
let context = CIContext()
```

- A **`CIContext`** renders a `CIImage` (the "recipe" for an image) into a `CGImage` (actual pixels).
- Contexts are expensive to create, so create one and keep it alive if rendering many images.
- The filter is `@State` so it can be swapped out later.

### Processing method

```swift
func applyProcessing() {
    currentFilter.intensity = Float(filterIntensity)

    guard let outputImage = currentFilter.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    let uiImage = UIImage(cgImage: cgImage)
    processedImage = Image(uiImage: uiImage)
}
```

- Sets intensity from `filterIntensity`, reads the filter output, renders it via the context, and stores the result in `processedImage` so it appears on screen.
- **Tip:** Core Image's sepia filter wants `Float`, not `Double`, hence `Float(filterIntensity)`.

### Finish `loadImage()`

Replace the `// more code to come` comment with:

```swift
let beginImage = CIImage(image: inputImage)
currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
applyProcessing()
```

- Filters have an `inputImage` property, but it's often broken and can crash the app.
- Using `setValue()` with `kCIInputImageKey` is much safer.

### Make the slider work

Changing `filterIntensity` doesn't automatically re-run `applyProcessing()`, so watch it with `onChange()`:

```swift
Slider(value: $filterIntensity)
    .onChange(of: filterIntensity, applyProcessing)
```

> **Tip:** If multiple views change the same value, or it's unclear what's changing it, attach the modifier at the end of the view instead.

> **Heads up:** Core Image is very fast on real iPhones but often very slow in the simulator.

---

## Key Takeaways

- Use optional state (`Image?`) and `if let` directly in a view to switch between placeholder and content.
- `ContentUnavailableView` makes empty states clear.
- `PhotosPicker` + `PhotosPickerItem` handles photo selection; load `Data`, then convert to `UIImage`.
- Core Image pipeline: `UIImage` → `CIImage` → filter → `CIImage` output → `CIContext` → `CGImage` → `UIImage` → SwiftUI `Image`.
- Use `setValue(_:forKey: kCIInputImageKey)` rather than `inputImage`.
- `@State` changes don't trigger side effects on their own; use `onChange()` to react.
- Keep `body` tidy by moving actions into methods.
