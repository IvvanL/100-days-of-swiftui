# Day 64 - Instafilter - project 13 part 3

## 1. Loading photos with PhotosPicker

`PhotosPicker` imports one or more photos from the user's library. It gives you a `PhotosPickerItem`, which is only a reference. You load the real data asynchronously and convert it to a SwiftUI `Image`.

### Single photo

```swift
import PhotosUI
import SwiftUI

@State private var pickerItem: PhotosPickerItem?
@State private var selectedImage: Image?

VStack {
    PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)

    selectedImage?
        .resizable()
        .scaledToFit()
}
.onChange(of: pickerItem) {
    Task {
        selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
    }
}
```

- Loading can take a few seconds for large images like panoramas.

### Multiple photos

- Use an array of items (`[PhotosPickerItem]`) and an array of loaded images (`[Image]`).
- In `.onChange`, clear the images array first, then loop over the items, load each one and append it.
- Show them with a `ForEach` inside a `ScrollView`.
- Limit selections with `maxSelectionCount: 3`.

### Customizing

- **Custom label:** pass a trailing closure, e.g. `Label("Select a picture", systemImage: "photo")`.
- **Filtering:** `.images` covers photos, screenshots, panoramas and more. Use `.any(of:)`, `.all(of:)` and `.not()` for finer control, e.g. `.any(of: [.images, .not(.screenshots)])`.

---

## 2. Sharing content with ShareLink

`ShareLink` lets users export content from your app. You provide the content and iOS shows the share sheet.

```swift
ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
```

- The simulator shows only a few sample options, so test on a real device.

### Options

- **Subject and message:** the URL is always included. Each receiving app decides whether to use the subject, the message, both or neither.
  ```swift
  ShareLink(item: url, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
  ```
- **Custom label:**
  ```swift
  ShareLink(item: url) {
      Label("Spread the word about Swift", systemImage: "swift")
  }
  ```
- **Preview:** use `SharePreview` to show the recipient what's being shared. It's required even for images, so store the image in a constant first.
  ```swift
  let example = Image(.example)

  ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
      Label("Click to share", systemImage: "airplane")
  }
  ```

---

## 3. Asking for an App Store review

The `.requestReview` environment key asks the user for a review. Apple handles the UI, skips the prompt if the user has already reviewed, and limits how often it appears.

```swift
import StoreKit

@Environment(\.requestReview) var requestReview

requestReview()
```

- **Don't tie it to a button.** It's only a *request*. The prompt won't show if alerts are disabled system-wide or the user has hit the maximum number of requests, so the button would silently do nothing.
- **Best practice:** call it automatically at a sensible moment, such as after the user has completed an important task several times.

---

## Key takeaways

- `PhotosPickerItem` is a lightweight reference. Nothing loads until you call `loadTransferable`, which is async and needs a `Task`.
- `ShareLink` needs a `SharePreview` for images and custom data. Subject and message are optional, and each receiving app decides how to use them.
- `requestReview()` is a request, not a guarantee, so trigger it automatically after meaningful usage.
````
