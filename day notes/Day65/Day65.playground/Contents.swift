// ** DAY 65 - INSTAFILTER - PROJECT 13 PART 4

// ** BUILDING OUR BASIC UI **

/*
 **Goal:** Build the app's basic interface, just enough to see how the pieces fit. The final UI has:
 1. A `NavigationStack` showing the app name at the top
 2. A box prompting the user to pick a photo (their imported image displays over it)
 3. An "Intensity" slider controlling how strongly Core Image filters apply (0.0–1.0)
 4. A share button to export the processed image

 **State properties (in `ContentView`):**
 ```swift
 @State private var processedImage: Image?
 @State private var filterIntensity = 0.5
 ```
 `processedImage` is optional because the user starts with no image selected.

 **Layout (`body`):**
 - `NavigationStack` > `VStack` containing: `Spacer`, image area, `Spacer`, an `HStack` with "Intensity" `Text` + `Slider(value: $filterIntensity)`, and an `HStack` with a "Change Filter" button, a `Spacer`, and a placeholder for the share button.
 - The two spacers guarantee space above and below the image area and keep the controls pinned to the bottom.
 - Padding: `.padding([.horizontal, .bottom])`, with `.navigationTitle("Instafilter")`.

 **Image area:** Show the image if one exists, otherwise a placeholder:
 ```swift
 if let processedImage {
     processedImage.resizable().scaledToFit()
 } else {
     ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
 }
 ```
 - Optional views can sit directly in a SwiftUI layout, and this pairs well with `ContentUnavailableView` since only one shows at a time.
 - It makes clear the blank space is intentional. Tapping doesn't do anything yet; that comes later.

 **Code cleanup tip:** Move button actions out of `body` into methods.
 ```swift
 func changeFilter() { }

 Button("Change Filter", action: changeFilter)
 ```
 - Not much logic in this button, but it's good practice.
 - Learners often put actions inline, but on real projects keeping `body` clean pays off long term.
*/

// ** IMPORTING AN IMAGE INTO SWIFTUI USING PHOTOSPICKER **

/*
 **Goal:** Let the user pick a photo from their library and display it in `ContentView`. It's a bit roundabout because Core Image doesn't work directly with SwiftUI images.

 **Step 1: Setup**
 - `import PhotosUI` at the top of `ContentView`
 - Add a state property to track the selection:
 ```swift
 @State private var selectedItem: PhotosPickerItem?
 ```

 **Step 2: Add a `PhotosPicker`**
 - Wrap the whole `if let processedImage` check in it, so the image or the `ContentUnavailableView` acts as the picker's label:
 ```swift
 PhotosPicker(selection: $selectedItem) {
     if let processedImage {
         processedImage.resizable().scaledToFit()
     } else {
         ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
     }
 }
 ```
 - **Tip:** The placeholder gets blue coloring to signal it's interactive. Add `.buttonStyle(.plain)` to the `PhotosPicker` to remove it.

 **Step 3: Load the selected image**
 - SwiftUI `Image` can't be fed into Core Image, so load raw `Data` from the selection and convert it to a `UIImage`.
 ```swift
 func loadImage() {
     Task {
         guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
         guard let inputImage = UIImage(data: imageData) else { return }

         // more code to come
     }
 }
 ```
 - This combines two earlier techniques: loading data from a `PhotosPicker` selection, and passing a `UIImage` into Core Image.

 **Step 4: Trigger loading on selection change**
 ```swift
 .onChange(of: selectedItem, loadImage)
 ```
 - It can go anywhere in `ContentView`, but attaching it to the `PhotosPicker` makes sense.

 **Result:** Running the app now brings up the photo selection UI so you can browse, but nothing happens with the selection yet.
*/

// ** BASIC IMAGE FILTERING USDING CORE IMAGE **

/*
 **Goal:** Let the user apply a Core Image filter to their selected photo. Start with one filter (sepia tone), then extend it later with a confirmation dialog.

 **Step 1: Imports (top of `ContentView.swift`)**
 ```swift
 import CoreImage
 import CoreImage.CIFilterBuiltins
 ```

 **Step 2: Add a filter and a context**
 ```swift
 @State private var currentFilter = CIFilter.sepiaTone()
 let context = CIContext()
 ```
 - A **`CIContext`** renders a `CIImage` (the "recipe" for an image) into a `CGImage` (actual pixels).
 - Contexts are expensive to create, so make one and keep it alive if you'll render many images.
 - The filter uses `@State` so it can be swapped out later.

 **Step 3: Process the image**
 ```swift
 func applyProcessing() {
     currentFilter.intensity = Float(filterIntensity)

     guard let outputImage = currentFilter.outputImage else { return }
     guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

     let uiImage = UIImage(cgImage: cgImage)
     processedImage = Image(uiImage: uiImage)
 }
 ```
 - Sets the filter intensity from `filterIntensity`, reads the filter's output, renders it with the context, then stores the result in `processedImage` so it shows on screen.
 - **Tip:** The sepia filter wants `Float`, not `Double`, hence `Float(filterIntensity)`. Paul says this will go away later.

 **Step 4: Finish `loadImage()`**
 Replace the `// more code to come` comment with:
 ```swift
 let beginImage = CIImage(image: inputImage)
 currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
 applyProcessing()
 ```
 - Filters have an `inputImage` property, but it's often broken and can crash the app. Using `setValue()` with `kCIInputImageKey` is much safer.

 **Result so far:** You can select an image and see sepia applied. The intensity slider does nothing yet, because changing `filterIntensity` doesn't automatically re-run `applyProcessing()`.

 **Step 5: Make the slider work**
 ```swift
 Slider(value: $filterIntensity)
     .onChange(of: filterIntensity, applyProcessing)
 ```
 - `onChange()` can go anywhere in the view hierarchy. Here it's attached to the slider since the slider changes the value directly.
 - **Tip:** If multiple views change the same value, or it's unclear what's changing it, attach the modifier at the end of the view instead.

 **Heads up:** Core Image is very fast on real iPhones but often very slow in the simulator, so expect laggy performance there.
*/

