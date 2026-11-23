# Day 67 - Instafilter - project 13 part 6 - Challenge

## Challenge list
1. Disable the Slider and Change Filter button when no image is selected. ✅ Done
2. Add more than one slider to control each input key (e.g. radius and intensity). ⬜ To do
3. Explore the Core Image filters and add three of my choosing to the app. ⬜ To do

## Part 1: Disable Slider and Change Filter button when no image is selected

### Goal
Grey out the Slider and the "Change Filter" button until the user has picked a photo.

### Solution
Use the `.disabled(_:)` modifier, which takes a Bool (`true` = disabled).

```swift
HStack {
    Text("Intensity")
    Slider(value: $filterIntensity)
        .onChange(of: filterIntensity, applyProcessing)
        .disabled(processedImage == nil)
}

HStack {
    Button("Change Filter", action: changeFilter)
        .disabled(processedImage == nil)

    Spacer()

    if let processedImage {
        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
    }
}
```

### What I learned
- `.disabled()` is attached like any other modifier, and `true` means the control is off.
- `selectedItem` becomes non-nil as soon as the user picks a photo, even if loading it fails.
- `processedImage` only becomes non-nil after the image has loaded and been processed, so it's the safer condition for "there is something to edit."
- Comparing an optional to `nil` (`== nil`) gives a Bool, which is what `.disabled()` needs.

### Tested
- [x] On launch, the Change Filter button is greyed out
- [x] On launch, the slider is greyed out
- [x] After picking a photo, both controls become usable

### Next up
- Part 3: choose three new Core Image filters and check which input keys they use
- Part 2: add separate sliders for each input key (radius, intensity, etc.)
