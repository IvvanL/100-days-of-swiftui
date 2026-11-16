// ** DAY 64 - INSTAFILTER - PROJECT 13 part 3 **

// ** LOADING PHOTOS FROM THE USER'S PHOTO LIBRARY **

/*
 **What it does:** `PhotosPicker` lets users import one or more photos from their library. It gives you a `PhotosPickerItem`, which is only a reference to the photo. You load the actual data asynchronously and convert it to a SwiftUI `Image`.

 ## Single photo: 5 steps

 1. Add `import PhotosUI` alongside `import SwiftUI`.
 2. Create two `@State` properties. One holds the selected item and the other holds the loaded image.
    ```swift
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    ```
 3. Add the picker to the view. It takes a title, a selection binding, and a `matching:` filter for the media type.
    ```swift
    PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
    ```
 4. Watch `pickerItem` with `.onChange` and call `loadTransferable(type:)` inside a `Task`. Loading can take a few seconds for large images like panoramas.
    ```swift
    .onChange(of: pickerItem) {
        Task {
            selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
        }
    }
    ```
 5. Display the image.
    ```swift
    selectedImage?
        .resizable()
        .scaledToFit()
    ```

 ## Multiple photos

 - Use an array of items: `@State private var pickerItems = [PhotosPickerItem]()`.
 - Use an array of loaded images: `@State private var selectedImages = [Image]()`.
 - You can no longer watch a single item, so in `.onChange(of: pickerItems)` you clear `selectedImages` first. Then you loop over `pickerItems`, load each with `loadTransferable`, and append the result.
 - Show the images with a `ForEach` inside a `ScrollView`.
 - Limit selections with `maxSelectionCount: 3`.

 ## Customizing

 - **Custom label:** pass a trailing closure, such as `Label("Select a picture", systemImage: "photo")`.
 - **Filtering:** `.images` includes photos, screenshots, panoramas and more. For finer control, use `.any(of:)`, `.all(of:)` and `.not()` with an array. For example, `.any(of: [.images, .not(.screenshots)])` matches all images except screenshots.

 ## Key takeaways

 - A `PhotosPickerItem` is a lightweight reference. Nothing loads until you call `loadTransferable`.
 - Loading is async, so it goes in a `Task` with `try await`.
 - The `matching:` parameter also allows videos, Live Photos and other media types.
*/

// ** HOW TO LET THE USER SHARE CONTENT WITH SHARELINK **

/*
 **What it does:** `ShareLink` lets users export content from your app, such as saving a picture, sending a link in Messages, or passing data to other apps. You supply the content and iOS shows the share sheet with every app that can handle it.

 ## Basic usage

 ```swift
 ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
 ```

 This creates a "Share" button with an icon, and tapping it opens the iOS share sheet. The simulator shows only a few sample options and some may not work, so test on a real device.

 ## Customization options

 1. **Subject and message:** attach extra text to the shared data.
    ```swift
    ShareLink(item: url, subject: Text("Learn Swift here"), message: Text("Check out the 100 Days of SwiftUI!"))
    ```
    The URL is always included. Whether the subject, the message, both or neither is used depends on the receiving app.

 2. **Custom button label:** provide your own label in a trailing closure.
    ```swift
    ShareLink(item: url) {
        Label("Spread the word about Swift", systemImage: "swift")
    }
    ```

 3. **Preview:** use `SharePreview` to give the recipient an idea of what's being shared. This matters most for complex or custom data. It's required even for an image, which you'd think is its own preview. To avoid repeating yourself, store the image in a constant first.
    ```swift
    let example = Image(.example)

    ShareLink(item: example, preview: SharePreview("Singapore Airport", image: example)) {
        Label("Click to share", systemImage: "airplane")
    }
    ```

 ## Key takeaways

 - You provide the content and iOS handles the list of destination apps.
 - Subject and message are optional extras, and each receiving app decides how to use them.
 - Sharing images (and custom data) requires a `SharePreview`.
 - Sharing keeps your app's data from feeling isolated from the rest of the user's life.
*/

// ** HOW TO ASK THE USER TO LEAVE AN APP STORE REVIEW **

/*
 **What it does:** SwiftUI has an environment key, `.requestReview`, that asks the user to leave an App Store review. Apple handles the UI, skips the prompt if the user has already reviewed, and limits how often it appears. You only need to make the request when you're ready.

 ## 3 steps

 1. Import StoreKit.
    ```swift
    import StoreKit
    ```
 2. Read the review requester from the environment.
    ```swift
    @Environment(\.requestReview) var requestReview
    ```
 3. Call it when the time is right.
    ```swift
    requestReview()
    ```

 ## Don't tie it to a button

 ```swift
 Button("Leave a review") {
     requestReview()
 }
 ```

 This is a bad idea because you're only *requesting* that the prompt appear. It may not show if:

 - the user has disabled these alerts system-wide, or
 - they've already hit the maximum number of review requests allowed.

 In those cases the button would silently do nothing.

 ## Best practice

 Call `requestReview()` automatically at a sensible moment. A good starting point is after the user has completed an important task several times, since that shows they've seen the value of your app.

 ## Key takeaways

 - Apple controls the UI, the frequency limits and the already-reviewed check.
 - `requestReview()` is a request, not a guarantee the prompt will appear.
 - Trigger it automatically after meaningful usage, not from a button.
*/
