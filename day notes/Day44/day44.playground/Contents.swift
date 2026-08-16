// ** PROGRAMMATIC NAVIGATION WITH NAVIGATIONSTACK **

/*
 - Programmatic navigation lets you move between views via code (e.g., after finishing some background work) rather than waiting for direct user interaction like a tap.
 - Implemented by binding a `NavigationStack`'s `path` to a `@State` array of your navigation data type.

 **Basic setup:**
 
 @State private var path = [Int]()

 NavigationStack(path: $path) {
     VStack { /* content */ }
     .navigationDestination(for: Int.self) { selection in
         Text("You selected \(selection)")
     }
 }
 
 **Key behaviors:**
 - Changing the `path` array automatically triggers navigation; pressing Back updates the array automatically too.
 - `path = [32]` — replaces the entire stack with a single destination (resets to root, then navigates to 32).
 - `path.append(64)` — pushes a new view on top of the existing stack.
 - `path = [32, 64]` — pushes multiple views at once (user must tap Back twice to return to root).
 - User-driven and programmatic navigation can be freely mixed — SwiftUI keeps `path` in sync regardless of navigation source.
 
*/

// ** NAVIGATING TO DIFFERENT DATA TYPES USING NAVIGATIONPATH **

/*
 Normally, a `NavigationStack` path can be an array of one specific type:

@State private var path = [Int]()
 
 That means your path can contain:

 [1, 2, 3, 4]
 
 But what if you want the path to contain **different types**, such as:

 [556, "Hello", 42, "Swift"]
 
 You can't use `[Int]` or `[String]` because they only accept one type.

 That's where `NavigationPath` comes in:

 @State private var path = NavigationPath()

 `NavigationPath` can store multiple types of `Hashable` data.


 ## Visual example

 Think of your navigation stack like a stack of screens:
 ┌──────────────────────────┐
 │      NavigationStack     │
 │                          │
 │  ┌────────────────────┐  │
 │  │  "Hello" Screen    │  │
 │  ├────────────────────┤  │
 │  │  556 Screen        │  │
 │  ├────────────────────┤  │
 │  │  Home Screen        │  │
 │  └────────────────────┘  │
 └──────────────────────────┘

 The `path` is essentially keeping track of what's been pushed:

 path
  │
  ▼
 ┌─────────────┐
 │     556     │  ← Int
 ├─────────────┤
 │   "Hello"   │  ← String
 └─────────────┘

 Because `NavigationPath` doesn't care that one is an `Int` and the other is a `String`, you can do:

 path.append(556)
 path.append("Hello")
 ---

 ## How SwiftUI knows which screen to show

 You tell SwiftUI what to do with each type:

 .navigationDestination(for: Int.self) { number in
     Text("You selected \(number)")
 }

 .navigationDestination(for: String.self) { text in
     Text("You selected \(text)")
 }

 So the flow is:
              path.append(556)
                     │
                     ▼
               ┌─────────┐
               │   556   │
               └────┬────┘
                    │
                    ▼
      navigationDestination(for: Int.self)
                    │
                    ▼
           "You selected 556"
 
 And:
              path.append("Hello")
                     │
                     ▼
              ┌───────────┐
              │  "Hello"  │
              └─────┬─────┘
                    │
                    ▼
    navigationDestination(for: String.self)
                    │
                    ▼
           "You selected Hello"

 ### The important distinction

 Without programmatic navigation, you can simply have multiple destinations:

 NavigationStack {
     // ...
 }
 .navigationDestination(for: Int.self) { ... }
 .navigationDestination(for: String.self) { ... }

 But once **you want to control the navigation stack yourself, you need:

 @State private var path = NavigationPath()

 and:
 
 NavigationStack(path: $path)
 
 Then you can manipulate navigation directly:

 path.append(556)
 path.append("Hello")

 You can also remove things from the path, which is one of the big advantages of managing navigation programmatically.

 ### 🔑 Remember it this way

 `NavigationPath` = a navigation stack that can hold different types of `Hashable` data.
 
 Think:

 Array<Int>          → [1, 2, 3]

 Array<String>       → ["A", "B", "C"]

 NavigationPath      → [1, "A", 42, "Hello"]
                          ↑    ↑
                        Int  String

 That's really the entire concept Paul is teaching here.

*/

// ** HOW TO MAKE A NAVIGATIONSTACK RETURN TO ITS ROOT VIEW PROGRAMMATICALLY **

/*
 Problem: Pop back to root view when deep in a `NavigationStack`
 
 **Two ways to clear the path:**
 1. If path is a plain array: call `path.removeAll()`
 2. If path is `NavigationPath`: reassign with `path = NavigationPath()`

 Challenge: The subview pushed onto the stack doesn't have direct access to the `path` property defined in the parent view.

 Solution: Use `@Binding` to share the path with the subview.

 - Parent (`ContentView`) holds `@State private var path = [Int]()`
 - Subview (`DetailView`) declares `@Binding var path: [Int]`
 - Parent passes it in as `path: $path` wherever the subview is created (initial view + `navigationDestination`)
 - Subview can then add a toolbar button to reset it:
 
 .toolbar {
     Button("Home") {
         path.removeAll()   // or path = NavigationPath()
     }
 }
 
 Note:*An alternative approach is storing the path in an external `@Observable` class instead of using `@Binding`. `@Binding` is the same mechanism used by controls like `TextField` and `Stepper` to read/write shared state.
*/

// ** HOW TO SAVE NAVIGATIONSTACK PATHS USING CODABLE **

/*
Saving/Loading NavigationStack Paths with Codable

Goal: Persist a `NavigationStack`'s navigation path to disk, so the app relaunches exactly where the user left off (however many views deep).

 **Core idea:** Move the path out of the view and into an external `@Observable` class (`PathStore`). Every time `path` changes (`didSet`), it auto-saves to a JSON file in the documents directory. When the class initializes, it tries to load that saved file back in.

 There are two versions depending on what type your path is:

 ### 1. Homogeneous array path (e.g. `[Int]`, `[String]`)
 Simplest case — arrays of a single `Codable` type encode/decode directly.

 @Observable
 class PathStore {
     var path: [Int] {
         didSet { save() }
     }

     private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

     init() {
         if let data = try? Data(contentsOf: savePath),
            let decoded = try? JSONDecoder().decode([Int].self, from: data) {
             path = decoded
             return
         }
         path = []   // fallback if nothing saved yet
     }

     func save() {
         do {
             let data = try JSONEncoder().encode(path)
             try data.write(to: savePath)
         } catch {
             print("Failed to save navigation data")
         }
     }
 }

 ### 2. `NavigationPath` (mixed/heterogeneous types)
 `NavigationPath` doesn't require `Codable`, only `Hashable` — so you can't just encode it directly. Instead:

 - Change the property type to `NavigationPath`
 - Decode using `NavigationPath.CodableRepresentation` (a special Codable-compatible wrapper), then rebuild a `NavigationPath` from it
 - In `save()`, first try to extract a Codable representation via `path.codable` — this returns `nil` if any object in the path can't be encoded, so you guard against that
 - Encode that representation (not the path itself) to JSON

 @Observable
 class PathStore {
     var path: NavigationPath {
         didSet { save() }
     }

     private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

     init() {
         if let data = try? Data(contentsOf: savePath),
            let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
             path = NavigationPath(decoded)
             return
         }
         path = NavigationPath()
     }

     func save() {
         guard let representation = path.codable else { return }
         do {
             let data = try JSONEncoder().encode(representation)
             try data.write(to: savePath)
         } catch {
             print("Failed to save navigation data")
         }
     }
 }

 ### Using it
 Bind your `NavigationStack`'s path to `pathStore.path` instead of a local `@State` array:

 struct ContentView: View {
     @State private var pathStore = PathStore()

     var body: some View {
         NavigationStack(path: $pathStore.path) {
             DetailView(number: 0)
                 .navigationDestination(for: Int.self) { i in
                     DetailView(number: i)
                 }
         }
     }
 }

 Key takeaway: Push/pop as much as you want — quit and relaunch the app, and the navigation stack restores to exactly where you left it, because the path is persisted to disk automatically on every change.
*/
