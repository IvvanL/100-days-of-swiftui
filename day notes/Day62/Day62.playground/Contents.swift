// DAY 62 - INSTAFILTER - PROJECT 13 PART 1

// ** HOW PROPERTY WRAPPERS BECOME STRUCTS **

/*

 **The setup:** `@State` plus a `$` binding lets a `Slider` change a value, and SwiftUI re-runs `body` so the UI updates (e.g. a `blurAmount` driving `.blur(radius:)`).

 **The problem:** Adding a `didSet` observer to the `@State` property doesn't work as you'd expect.
 - Moving the slider changes the blur, but the `didSet` (e.g. a `print`) never fires.
 - Setting the value directly in code (e.g. a button setting `blurAmount`) does trigger `didSet`.

 **Why it happens:**
 - Property wrappers wrap your property in a struct. A `@State var name: String` is really a `State<String>`.
 - `State` is declared as `@propertyWrapper public struct State<Value> : DynamicProperty`. The `@propertyWrapper` attribute is what lets you write `@State`.
 - Its `wrappedValue` is declared as `{ get nonmutating set }`. Setting the value doesn't change the struct itself. SwiftUI stores the value elsewhere, where it can be modified freely. That's how a struct can "change" even though view structs are fixed.
 - Your `didSet` is attached to the property, but with `@State` it effectively observes the wrapper struct, which never changes.
 - A binding bypasses the setter and writes directly to the stored value, so the observer never runs. Setting the property directly goes through the setter, so it does.

 **Handy tip:** Xcode's Open Quickly (`Cmd+Shift+O`) lets you look up any type, such as `State`, and view SwiftUI's generated interface.

*/

// ** RESPONDING TO STATE CHANGES USING onChange() **

/*
 **The problem (recap):** A `didSet` on a `@State` property doesn't fire when a binding (like a `Slider`'s `$blurAmount`) changes the value. SwiftUI sends binding updates to property wrappers in a way that bypasses property observers.

 **The fix:** The `onChange()` modifier tells SwiftUI to run a function whenever a particular value changes.

 ```swift
 Slider(value: $blurAmount, in: 0...20)
     .onChange(of: blurAmount) { oldValue, newValue in
         print("New value is \(newValue)")
     }
 ```

 - SwiftUI automatically passes in both the **old and new value**.
 - Everything else stays the same: you still declare `@State private var blurAmount = 0.0` and still use `.blur(radius: blurAmount)`.
 - Inside the closure you can do anything: call methods, run an algorithm to apply the change, and so on.

 **Tip:** You can attach `onChange()` anywhere in the view hierarchy, but Paul prefers putting it near the thing that's actually changing.

 **Three variants:**
 1. **Two parameters (old and new value):** the modern default, shown above.
 2. **No parameters:** for when you only care that the value changed, not what it changed to.
 3. **New value only:** deprecated as of iOS 17. Only use it if you need to support iOS 16 and earlier.

 **Using the locker story:** `onChange()` is the bell on the locker itself. It rings no matter who changes the contents, whether that's the button or the slider's shortcut.

 **Takeaway:** Don't use `didSet` to react to `@State` changes. Use `.onChange(of:)` instead.
*/

// ** SHOWING MULTIPLE OPTIONS WITH CONFIRMATIONDIALOG() **

/*
 **What it is:** `confirmationDialog()` is an alternative to `alert()` that lets you offer many buttons. SwiftUI already gave us `alert()` (important choices) and `sheet()` (whole views on top of the current one).

 **How it looks vs. an alert (on iPhone):**
 - **Alert:** appears in the center of the screen and must be dismissed by choosing a button.
 - **Confirmation dialog:** slides up from the bottom, can hold lots of buttons, and can be dismissed with Cancel or by tapping outside the options.

 **What they share:**
 - Both are created by attaching a modifier to your view hierarchy.
 - Both are shown automatically when a condition is true.
 - Both are filled with buttons for different actions.
 - Both can have a second closure for an extra message.

 **The setup:** A button that flips a Boolean, plus a property to change.

 ```swift
 @State private var showingConfirmation = false
 @State private var backgroundColor = Color.white

 Button("Hello, World!") {
     showingConfirmation = true
 }
 .frame(width: 300, height: 300)
 .background(backgroundColor)
 ```

 **The modifier:** It takes three things: a **title**, an **`isPresented` binding** (the Boolean), and a **closure of buttons** (usually a trailing closure).

 ```swift
 .confirmationDialog("Change background", isPresented: $showingConfirmation) {
     Button("Red") { backgroundColor = .red }
     Button("Green") { backgroundColor = .green }
     Button("Blue") { backgroundColor = .blue }
     Button("Cancel", role: .cancel) { }
 } message: {
     Text("Select a new color")
 }
 ```

 **Key points:**
 - Buttons stack vertically in the order you provide them.
 - It's good practice to end with a **cancel button** (`role: .cancel`). Tapping outside also cancels, but an explicit option is better for users.
 - The optional `message:` closure adds extra text below the title.

 **Result:** Tapping the button slides up the dialog, and choosing a color changes the background.

 **Takeaway:** Use `confirmationDialog()` instead of `alert()` when you need more than a couple of choices. Set a `@State` Boolean to `true` to show it.
*/
