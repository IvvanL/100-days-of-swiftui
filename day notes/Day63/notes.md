# Day 63 - Instafilter - project 13 part 2

## 1. Integrating Core Image with SwiftUI

Core Image is Apple's framework for **modifying existing images** (sepia, blur, pixellate, etc.). It doesn't integrate neatly with SwiftUI, so you convert between several image types.

### The four image types

| Type | Framework | Notes |
|---|---|---|
| `Image` | SwiftUI | Display only. It's the end point of the pipeline. |
| `UIImage` | UIKit | General-purpose image type (bitmap, vector, animation). |
| `CGImage` | Core Graphics | A simple 2D array of pixels. |
| `CIImage` | Core Image | An "image recipe", not actual pixels until rendered. |

**Conversions:**
- `UIImage` ⇄ `CGImage`
- `UIImage` / `CGImage` → `CIImage`
- `CIImage` → `CGImage` (via `CIContext`)
- `UIImage` / `CGImage` → SwiftUI `Image`

### Setup

```swift
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
}
```

- `image` is an optional `@State`, and SwiftUI handles optional views fine.
- `.onAppear` goes on the `VStack`, because it wouldn't fire if attached to a `nil` image.

### The pipeline

```swift
func loadImage() {
    let inputImage = UIImage(resource: .example)   // asset catalog -> UIImage
    let beginImage = CIImage(image: inputImage)    // UIImage -> CIImage

    let context = CIContext()                      // renders processed data to a CGImage
    let currentFilter = CIFilter.sepiaTone()       // does the transformation

    currentFilter.inputImage = beginImage
    currentFilter.intensity = 1                    // 0 = original, 1 = full sepia

    guard let outputImage = currentFilter.outputImage else { return }
    guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

    let uiImage = UIImage(cgImage: cgImage)        // CGImage -> UIImage
    image = Image(uiImage: uiImage)                // UIImage -> SwiftUI Image
}
```

**Flow:** `UIImage` → `CIImage` → *(filter)* → `CIImage` → `CGImage` → `UIImage` → `Image`

- **Filter** does the work. **Context** renders the result.
- `outputImage` and `createCGImage` both return optionals, so use `guard let`.
- `CGImage` → `Image` directly is possible but needs extra parameters, so going via `UIImage` is simpler.

### Other filters (modern API)

```swift
let f = CIFilter.pixellate();        f.scale = 100
let f = CIFilter.crystallize();      f.radius = 200
let f = CIFilter.twirlDistortion();  f.radius = 1000
f.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
```

The modern API uses exact property names and types, which is best for precise adjustments.

### Older API: setting values dynamically

Works with **any** filter by sending only the values it supports:

```swift
let inputKeys = currentFilter.inputKeys

if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
if inputKeys.contains(kCIInputRadiusKey)    { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
if inputKeys.contains(kCIInputScaleKey)     { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
```

- It works like `UserDefaults`: values are set by key, and the `kCIInput…` keys are really strings.
- You can swap filters and the code keeps working.

### Key takeaways
- `Image` is only for displaying. Use `UIImage`, `CGImage` and `CIImage` for processing.
- `CIImage` is a recipe, so a `CIContext` is needed to render it.
- Always unwrap optionals in the pipeline safely.
- Use the modern API for precision and the key-based API for flexibility.

---

## 2. Showing Empty States with `ContentUnavailableView`

A built-in SwiftUI view (iOS 17+) that shows a standard **empty state** when there's nothing to display, such as when:
- The user hasn't created any data yet.
- A search returns no results.

### Simple: title + SF Symbol

```swift
ContentUnavailableView("No snippets", systemImage: "swift")
```

### With a description

```swift
ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))
```

The description is a `Text` view, so it can be styled (font, color, etc.).

### Full control: title, description and actions

```swift
ContentUnavailableView {
    Label("No snippets", systemImage: "swift")
} description: {
    Text("You don't have any saved snippets yet.")
} actions: {
    Button("Create Snippet") {
        // create a snippet
    }
    .buttonStyle(.borderedProminent)
}
```

### Key takeaways
- It's much better than a blank screen on first launch.
- Use the simple initializer for quick empty states.
- Use the closure version to add custom layouts and call-to-action buttons.
````
