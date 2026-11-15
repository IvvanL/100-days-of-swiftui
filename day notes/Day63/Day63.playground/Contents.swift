// ** DAY 63 PROJECT 12 PART 2**

// ** INTEGRATING CORE IMAGE WITH SWIFTUI **

/*
 ## Core idea
 Core Image is Apple's framework for **modifying existing images** (sepia, blur, pixellate, vignette, etc.). It doesn't fit SwiftUI neatly, so you have to convert between several image types.

 ## The four image types
 | Type | Framework | What it is |
 |---|---|---|
 | `Image` | SwiftUI | A view for display only. You can't edit it or write it to disk. It's the end point. |
 | `UIImage` | UIKit | Powerful, general image type (bitmap, vector, animation). Closest to SwiftUI's `Image`. |
 | `CGImage` | Core Graphics | A simple 2D array of pixels. |
 | `CIImage` | Core Image | An "image recipe". It holds the info to make an image but isn't pixels until rendered. |

 **Conversions that work:**
 - `UIImage` ⇄ `CGImage`
 - `UIImage` / `CGImage` → `CIImage`
 - `CIImage` → `CGImage` (via a `CIContext`)
 - `UIImage` / `CGImage` → SwiftUI `Image`

 ## Setup
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
 - `.onAppear` goes on the `VStack`, not the image. If the image is `nil`, `onAppear` wouldn't fire.

 ## The pipeline
 ```swift
 func loadImage() {
     let inputImage = UIImage(resource: .example)      // asset catalog -> UIImage
     let beginImage = CIImage(image: inputImage)       // UIImage -> CIImage

     let context = CIContext()                         // turns processed data into a CGImage
     let currentFilter = CIFilter.sepiaTone()          // does the actual work

     currentFilter.inputImage = beginImage
     currentFilter.intensity = 1                       // 0 = original, 1 = full sepia

     guard let outputImage = currentFilter.outputImage else { return }                        // CIImage
     guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }  // CGImage
     let uiImage = UIImage(cgImage: cgImage)           // CGImage -> UIImage
     image = Image(uiImage: uiImage)                   // UIImage -> SwiftUI Image
 }
 ```
 **Flow:** `UIImage` → `CIImage` → *(filter)* → `CIImage` → `CGImage` → `UIImage` → `Image`

 - **Filter** = does the transformation.
 - **Context** = renders the result into a `CGImage`.
 - Both `outputImage` and `createCGImage` return optionals, so use `guard let`.
 - You *can* go `CGImage` → `Image` directly, but it needs extra parameters, so going via `UIImage` is simpler.

 ## Other filters (modern API)
 ```swift
 let f = CIFilter.pixellate();        f.scale = 100
 let f = CIFilter.crystallize();      f.radius = 200
 let f = CIFilter.twirlDistortion();  f.radius = 1000
 f.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
 ```
 The modern API uses exact property names and types, so it's best for precise adjustments.

 ## Older API: dynamic values
 Lets you set values on **any** filter, applying only the ones it supports:
 ```swift
 let inputKeys = currentFilter.inputKeys

 if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(amount, forKey: kCIInputIntensityKey) }
 if inputKeys.contains(kCIInputRadiusKey)    { currentFilter.setValue(amount * 200, forKey: kCIInputRadiusKey) }
 if inputKeys.contains(kCIInputScaleKey)     { currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey) }
 ```
 - It works like `UserDefaults`: values are set by key, and the `kCIInput…` keys are really strings.
 - You can swap the filter for another and the code keeps working.
 - This project uses it for that flexibility.

 ## Key takeaways
 - `Image` is only for displaying. Use `UIImage`, `CGImage` and `CIImage` for processing.
 - `CIImage` is a recipe, not pixels, so a `CIContext` is needed to render it.
 - Always unwrap optionals in the pipeline safely.
 - Use the modern API for precision and the key-based API for flexibility.
*/


// ** SHOWING EMPTY STATES WITH CONTENTUNAVAILABLEVIEW **

/*
 ## What it is
 A built-in SwiftUI view (iOS 17+) that shows a standard **empty state** UI when your app has nothing to display. Use it instead of a blank screen when:
 - The user hasn't created any data yet (e.g. no saved snippets).
 - A search returns no results.

 ## Three ways to use it

 **1. Simple: title + SF Symbol**
 ```swift
 ContentUnavailableView("No snippets", systemImage: "swift")
 ```
 Shows a large icon with the title text below it.

 **2. With a description**
 ```swift
 ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))
 ```
 The description is a `Text` view, so you can style it (custom font, color, etc.).

 **3. Full control: title, description and actions**
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
 Each part is its own view, and `actions` lets you add buttons that help the user get started.

 ## Key takeaways
 - It's much better than showing a blank screen on first launch.
 - The simple version needs just a title and an SF Symbol.
 - Use the closure version (`Label` + `description` + `actions`) for custom layouts and call-to-action buttons.
*/
