// ** DAY 66 - INSTAFILTER - PROJECT 13 PART 5 **

// ** CUSTOMIZING OUR FILTER USING CONFIRMATIONDIALOG() **

/*
 **Goal:** Let users pick which Core Image filter to apply, instead of being stuck with sepia tone.

 ## Steps

 1. **Add state to track the dialog:**
    ```swift
    @State private var showingFilters = false
    ```
 2. **Attach `confirmationDialog()`** below the navigation title. It works like `alert()`: a title plus a condition, and it shows when the condition becomes true. On iPhone it's a list of buttons that slides up from the bottom.
    ```swift
    .confirmationDialog("Select a filter", isPresented: $showingFilters) { /* buttons */ }
    ```
 3. **Set `showingFilters = true` inside `changeFilter()`.**
 4. **Change the filter type.** `CIFilter.sepiaTone()` returns a `CIFilter` that conforms to the `CISepiaTone` protocol. Apple wraps the string-based Core Image API in protocols for type safety. To swap filters, drop that protocol-specific type:
    ```swift
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    ```
    This loses the `.intensity` property, so use `setValue(_:forKey:)` instead.
 5. **Add a helper that swaps the filter and reloads:**
    ```swift
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    ```
    *Tip: to speed things up, store `beginImage` in `@State` so the image isn't reloaded on every filter change.*
 6. **Add the dialog buttons:** Crystallize, Edges, Gaussian Blur, Pixellate, Sepia Tone, Unsharp Mask and Vignette. Each calls `setFilter(CIFilter.xxx())`. A Cancel button uses `role: .cancel`. You can type `CIFilter.` to see other options.

 ## The crash and the fix

 - With the protocol type gone, `setValue(_:forKey:)` has **no type safety**. Setting a key the filter doesn't support crashes the app. For example, Gaussian Blur has no intensity key.
 - **Fix:** read `currentFilter.inputKeys` and only set the keys the current filter supports:
   ```swift
   let inputKeys = currentFilter.inputKeys

   if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
   if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
   if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
   ```
 - One slider now drives different parameters per filter: intensity for sepia, radius for blur, and scale for filters like pixellate.
 - **Scale values sensibly.** A 1-pixel blur is invisible, so the radius is multiplied by 200.

 ## Key takeaways

 - `confirmationDialog()` is used the same way as `alert()`.
 - Explicitly typing as `CIFilter` lets you swap filters, but you lose protocol type safety.
 - Always check `inputKeys` before calling `setValue(_:forKey:)` to avoid crashes.
 - Constants to remember: `kCIInputIntensityKey`, `kCIInputRadiusKey` and `kCIInputScaleKey`.
*/

// ** SHARING AN IMAGE USING SHARELINK **

/*
 **Goal:** Finish the Instafilter project with two features: sharing the processed image, and prompting the user for an App Store review once they've used the app enough.

 ## 1. Share the image with `ShareLink`

 - `ShareLink` shares text, URLs, images and more in one line, using the system share sheet automatically.
 - Replace the `// share the picture` comment with a check that an image exists, then show the button:
   ```swift
   if let processedImage {
       ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
   }
   ```
 - `SharePreview` sets the title and thumbnail shown in the share sheet.
 - Test on a real device to see how actual apps handle the image.

 ## 2. Ask for an App Store review

 - **Timing matters.** Ask only after the user has felt the app's benefit. Asking too early makes them likelier to ignore it.
 - The trigger here is **20 filter changes**, enough that they've gone through the options more than once.
 - **Setup:**
   - `import StoreKit` in `ContentView.swift`.
   - Add two properties:
     ```swift
     @AppStorage("filterCount") var filterCount = 0
     @Environment(\.requestReview) var requestReview
     ```
   - `@AppStorage` makes the count persist between launches.
 - **Add to the end of `setFilter()`:**
   ```swift
   filterCount += 1

   if filterCount >= 20 {
       requestReview()
   }
   ```
 - **Fix the resulting Xcode error.** Requesting a review must run on the **main actor**, the part of the app that can work with the UI. Swift can't guarantee that inside a SwiftUI view method, so mark the method explicitly:
   ```swift
   @MainActor func setFilter(_ filter: CIFilter) {
   ```
 - *Tip: while testing, lower the threshold from 20 to about 5.*

 ## Key takeaways

 - `ShareLink(item:preview:)` gives you the standard share sheet with minimal code.
 - Unwrap the optional image before showing the `ShareLink`.
 - Use `@Environment(\.requestReview)` with `import StoreKit` to prompt for reviews.
 - Use `@AppStorage` to count actions across launches, and `@MainActor` on code that triggers UI-related requests.
 - This completes the app: import a picture, apply a filter, and share it.
*/
