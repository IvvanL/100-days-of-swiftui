# Day 66 - Instafilter - project 13 part 5

---

## 1. Customizing the filter with `confirmationDialog()`

**Goal:** Let users choose which Core Image filter to apply instead of being stuck with sepia tone.

### Steps

1. Add state: `@State private var showingFilters = false`
2. Attach the dialog below the navigation title. It works like `alert()` and slides up from the bottom on iPhone.
   ```swift
   .confirmationDialog("Select a filter", isPresented: $showingFilters) { /* buttons */ }
   ```
3. Set `showingFilters = true` inside `changeFilter()`.
4. Change the filter's type so any filter can be assigned (this drops the `CISepiaTone` protocol, and with it `.intensity`):
   ```swift
   @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
   ```
5. Add a helper that swaps the filter and reloads the image:
   ```swift
   func setFilter(_ filter: CIFilter) {
       currentFilter = filter
       loadImage()
   }
   ```
   *Tip: store `beginImage` in `@State` to avoid reloading the image on every filter change.*
6. Add buttons for Crystallize, Edges, Gaussian Blur, Pixellate, Sepia Tone, Unsharp Mask and Vignette, each calling `setFilter(CIFilter.xxx())`, plus a Cancel button with `role: .cancel`.

### The crash and the fix

- Core Image's underlying API is string-based. Apple's protocols (like `CISepiaTone`) add type safety on top.
- Without the protocol, `setValue(_:forKey:)` has **no safety**. Setting an unsupported key (e.g. intensity on Gaussian Blur) crashes the app.
- **Fix:** check `inputKeys` first and only set supported keys:
  ```swift
  let inputKeys = currentFilter.inputKeys

  if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
  if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
  if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
  ```
- One slider now drives different parameters per filter: intensity (sepia), radius (blur), scale (pixellate and similar).
- Scale values sensibly. A 1-pixel blur is invisible, so the radius is multiplied by 200.

### Takeaways

- `confirmationDialog()` is used the same way as `alert()`.
- Typing as plain `CIFilter` allows swapping filters but loses type safety.
- Always check `inputKeys` before `setValue(_:forKey:)`.
- Constants: `kCIInputIntensityKey`, `kCIInputRadiusKey`, `kCIInputScaleKey`.

---

## 2. Sharing an image with `ShareLink`

**Goal:** Finish the app by adding image sharing and an App Store review prompt.

### ShareLink

- Shares text, URLs, images and more in one line using the system share sheet.
- Replace the `// share the picture` comment:
  ```swift
  if let processedImage {
      ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
  }
  ```
- `SharePreview` sets the title and thumbnail shown in the share sheet.
- Test on a real device to see how real apps handle the image.

### Requesting a review

- **Timing matters.** Ask only after the user has felt the app's benefit. Here the trigger is **20 filter changes**.
- Setup:
  - `import StoreKit`
  - Add the properties:
    ```swift
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    ```
  - `@AppStorage` persists the count between launches.
- Add to the end of `setFilter()`:
  ```swift
  filterCount += 1

  if filterCount >= 20 {
      requestReview()
  }
  ```
- **Xcode error fix:** requesting a review must run on the main actor, so mark the method:
  ```swift
  @MainActor func setFilter(_ filter: CIFilter) {
  ```
- *Tip: lower the threshold to about 5 while testing.*

### Takeaways

- `ShareLink(item:preview:)` gives the standard share sheet with minimal code.
- Unwrap the optional image before showing the `ShareLink`.
- `@Environment(\.requestReview)` plus `import StoreKit` prompts for reviews.
- Use `@AppStorage` to count actions across launches, and `@MainActor` for UI-related requests.
- The app is complete: import a picture, apply a filter, share it.
