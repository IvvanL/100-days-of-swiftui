// DAY 53 - BOOKWORM - PROJECT 11

// ** CREATING A CUSTOM COMPONENT WITH @BINDING **

/*
 **What @Binding does**
 - Lets a view share a simple `@State` value (Bool, Int, String, array, etc.) with another view, so both read and write the *same* value.
 - Example: `Toggle("Remember Me", isOn: $rememberMe)` works because the toggle holds a binding to your `@State` property and changes it directly.

 **@Bindable vs. @Binding**
 - **@Bindable**: for shared *classes* that use the `@Observable` macro. Create the object with `@State` in one view, then use `@Bindable` in other views so they can make bindings to its properties.
 - **@Binding**: for simple *value-type* data (not an `@Observable` class) that you want to pass around and modify from multiple views.

 **Why it matters for custom components**
 - Custom UI components are just SwiftUI views. They can have local `@State`, but `@Binding` properties are what let them connect to whatever view uses them.

 **The example: `PushButton`**
 - A custom button that stays "down" when pressed. It has a title, an `isOn` Bool, customizable on/off gradient colors, a capsule shape, and a shadow that disappears when on.
 - **The bug**: with `@State var isOn: Bool`, the button only receives an initial value from `ContentView`. After that it toggles its own copy, so `ContentView`'s `rememberMe` never changes and the text below always says "Off".
 - **The cause**: two sources of truth, one in `ContentView` and one in `PushButton`, with one-way data flow.

 **The fix (two changes)**
 1. In `PushButton`, change the property to `@Binding var isOn: Bool`.
 2. In `ContentView`, pass the binding with a dollar sign: `PushButton(title: "Remember Me", isOn: $rememberMe)`.

 **Key takeaways**
 - The `$` passes the binding itself, not just the Bool inside it.
 - `@Binding` creates a two-way connection, so a change in either view updates the other.
 - The button just toggles a Boolean and has no idea anything else is watching it.
*/

/*
** SAMPLE CODE **
 import SwiftUI

 struct PushButton: View {
     let title: String
     @Binding var isOn: Bool
     
     var onColors = [Color.red, Color.yellow]
     var offColors = [Color(white: 0.6), Color(white: 0.4)]
     
     var body: some View {
         Button(title) {
             isOn.toggle()
         }
         .padding()
         .background(LinearGradient(colors: isOn ? onColors : offColors, startPoint: .top, endPoint: .bottom))
         .foregroundStyle(.white)
         .clipShape(.capsule)
         .shadow(radius: isOn ? 0 : 5)
     }
 }

 struct ContentView: View {
     @State private var rememberMe = false
     
     var body: some View {
         PushButton(title: "Remember Me", isOn: $rememberMe)
         Text(rememberMe ? "On" : "Off")
     }
 }

 #Preview {
     ContentView()
 }
*/

// ** ACCEPTING MULTI-LINE TEXT INPUT WITH TEXTEDITOR **

/*
 **What TextEditor is**
 - A view for longer text input. It takes a two-way binding to a string (like `TextField`) but allows multiple lines and gives the user a large text area.
 - Simpler than `TextField`: you can't change its style or add placeholder text, you just bind it to a string.
 - Keep it inside the safe area (e.g. in a `NavigationStack` or `Form`), otherwise typing gets awkward.

 **Example: simplest notes app**
 
 struct ContentView: View {
     @AppStorage("notes") private var notes = ""

     var body: some View {
         NavigationStack {
             TextEditor(text: $notes)
                 .navigationTitle("Notes")
                 .padding()
         }
     }
 }

 - **Tip**: `@AppStorage` isn't secure, so never use it for private information.

 **Alternative: TextField with an axis**
 - `TextField("Enter your text", text: $notes, axis: .vertical)` starts as a single line and grows as the user types, like the iMessage text box.
 - Can be styled, e.g. with `.textFieldStyle(.roundedBorder)`.

 **When to use which**
 - **TextEditor**: shows a big text space up front, so users know they can type a lot.
 - **TextField (vertical axis)**: expands automatically and takes less space until needed.
 - You'll use both at different times.

 **Key takeaway**
 - SwiftUI often changes how views look inside a `Form`, so test both options inside and outside a `Form`.
*/

/*
 ** SAMPLE CODE **
 import SwiftUI

 struct ContentView: View {
     @AppStorage("notes") private var notes = ""
     
     var body: some View {
         NavigationStack {
             TextField("Enter your text", text: $notes, axis: .vertical)
                 .textFieldStyle(.roundedBorder)
                 .navigationTitle("Notes")
                 .padding()
         }
     }
 }

 #Preview {
     ContentView()
 }
*/

// ** INTRODUCTION TO SWIFTDATA AND SWIFTUI **

/*
 **What SwiftData is**
 - An object graph and persistence framework: you define objects and their properties, then read and write them from permanent storage.
 - More capable than `Codable` + `UserDefaults`: it can sort and filter data, handle very large datasets, and supports iCloud syncing, lazy loading, undo/redo, and more.
 - Set it up by hand (don't enable SwiftData when creating the Xcode project, since it adds pointless example code).

 **Setup: three steps**

 **1. Define the model**
 - Add `import SwiftData` and change `@Observable` to `@Model`:

 import SwiftData

 @Model
 class Student {
     var id: UUID
     var name: String

     init(id: UUID, name: String) {
         self.id = id
         self.name = name
     }
 }
 
 - `@Model` lets SwiftData save, query, delete, and link objects. It builds on the same observation system as `@Observable`, so it works well with SwiftUI.

 **2. Create the model container**
 - In the `App` struct (e.g. `BookwormApp.swift`), add `import SwiftData` and attach a modifier to `WindowGroup`:
 
 WindowGroup {
     ContentView()
 }
 .modelContainer(for: Student.self)

 - The model container is where SwiftData stores its data. It creates the database file on first launch and reuses it afterward.
 - `@main` marks the app's launch point. `WindowGroup` lets the app appear in multiple windows (matters mostly on iPad and macOS).

 **3. Use the model context**
 - The model context is the "live" in-memory version of your data. Changes exist only in memory until saved, which is faster than constantly hitting disk.
 - It's created automatically by `modelContainer()` as the *main context* and placed in SwiftUI's environment.
 - Access it with:
 
 @Environment(\.modelContext) var modelContext
 
 **Reading data with @Query**
 - `@Query` is a property wrapper (available with `import SwiftData`) that loads data and keeps it in sync as objects are added or removed.
 
 @Query var students: [Student]
 
 - With no sorting or filtering specified, it returns all students. You can then use it like a normal array:
 
 NavigationStack {
     List(students) { student in
         Text(student.name)
     }
     .navigationTitle("Classroom")
}

 **Writing data**
 - Create an object and insert it into the model context:

 .toolbar {
     Button("Add") {
         let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
         let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]

         let chosenFirstName = firstNames.randomElement()!
         let chosenLastName = lastNames.randomElement()!

         let student = Student(id: UUID(), name: "\(chosenFirstName) \(chosenLastName)")
         modelContext.insert(student)
     }
 }
 
 - Force unwrapping `randomElement()` is safe here because the arrays are hard-coded and non-empty (or use nil coalescing if you prefer).
 - Inserted students appear in the list and persist across app relaunches, because SwiftData saves automatically.

 **Key takeaways**
 - **Model** (`@Model`): defines the data.
 - **Model container** (`.modelContainer(for:)`): where the data is stored.
 - **Model context** (`@Environment(\.modelContext)`): the live, in-memory working copy used to insert and change data.
 - **Query** (`@Query`): retrieves and stays synced with stored data.
 - After this overview, reset the project: reset `ContentView.swift` and `BookwormApp.swift`, and delete `Student.swift`.
*/
