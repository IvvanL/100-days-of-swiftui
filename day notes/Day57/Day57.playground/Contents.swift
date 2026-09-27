// ** DAY 57 PROJECT 12 **

// ** EDITING SWIFTDATA MODEL OBJECTS **

/*

 **Core idea:** SwiftData model objects (`@Model`) use the same observation system as `@Observable`, so they work seamlessly with SwiftUI and `@Bindable` for editing.

 **1. Define the model**
 ```swift
 @Model
 class User {
     var name: String
     var city: String
     var joinDate: Date

     init(name: String, city: String, joinDate: Date) {
         self.name = name
         self.city = city
         self.joinDate = joinDate
     }
 }
 ```

 **2. Attach a container at the app level**
 ```swift
 WindowGroup {
     ContentView()
 }
 .modelContainer(for: User.self)
 ```

 **3. Edit with `@Bindable`** — works exactly like a plain `@Observable` class, but changes are automatically persisted:
 ```swift
 struct EditUserView: View {
     @Bindable var user: User

     var body: some View {
         Form {
             TextField("Name", text: $user.name)
             TextField("City", text: $user.city)
             DatePicker("Join Date", selection: $user.joinDate)
         }
         .navigationTitle("Edit User")
         .navigationBarTitleDisplayMode(.inline)
     }
 }
 ```

 **4. Previews need their own container** (in-memory, throwaway):
 ```swift
 #Preview {
     do {
         let config = ModelConfiguration(isStoredInMemoryOnly: true)
         let container = try ModelContainer(for: User.self, configurations: config)
         let user = User(name: "Taylor Swift", city: "Nashville", joinDate: .now)
         return EditUserView(user: user)
             .modelContainer(container)
     } catch {
         return Text("Failed to create container: \(error.localizedDescription)")
     }
 }
 ```
 *Note: inserting `user` into the context isn't required here — `@Bindable` only needs the object to be observable, not persisted.*

 **5. Building a full add/edit flow (ContentView)**
 - Get context, query, and navigation path:
 ```swift
 @Environment(\.modelContext) var modelContext
 @Query(sort: \User.name) var users: [User]
 @State private var path = [User]()
 ```
 - List + navigate to edit view:
 ```swift
 NavigationStack(path: $path) {
     List(users) { user in
         NavigationLink(value: user) {
             Text(user.name)
         }
     }
     .navigationTitle("Users")
     .navigationDestination(for: User.self) { user in
         EditUserView(user: user)
     }
 }
 ```
 - Add a new user and jump straight to editing it:
 ```swift
 .toolbar {
     Button("Add User", systemImage: "plus") {
         let user = User(name: "", city: "", joinDate: .now)
         modelContext.insert(user)
         path = [user]
     }
 }
 ```

 **Takeaway:** Adding and editing use the same view — create an empty `User`, insert it, and navigate to it immediately. This mirrors the approach Apple's Notes app uses (minus the auto-delete-if-empty behavior).
*/


// ** FILTERING @QUERY USING PREDICATE **

/*
 **Source:** Paul Hudson, Hacking with Swift (May 29, 2024)

 **Core idea:** `@Query` can filter SwiftData objects using `#Predicate` — a macro that converts Swift-like code into rules applied directly to the underlying database (not real executed Swift code).

 **Setup (same `User` model as before)**
 ```swift
 @Environment(\.modelContext) var modelContext
 @Query(sort: \User.name) var users: [User]
 ```

 Sample data button for testing:
 ```swift
 Button("Add Samples", systemImage: "plus") {
     try? modelContext.delete(model: User.self) // clears old data first

     let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
     let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
     let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
     let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))

     modelContext.insert(first)
     modelContext.insert(second)
     modelContext.insert(third)
     modelContext.insert(fourth)
 }
 ```

 **1. Basic filter — case-sensitive `contains()`**
 ```swift
 @Query(filter: #Predicate<User> { user in
     user.name.contains("R")
 }, sort: \User.name) var users: [User]
 ```
 - Runs once per loaded object; return `true` to include it.
 - `contains("R")` is case-sensitive — only matches capital R (so "Rosa" and "Roy" match, but not "Ed Sheeran" despite lowercase "r").

 **2. Case-insensitive filter — `localizedStandardContains()`**
 ```swift
 @Query(filter: #Predicate<User> { user in
     user.name.localizedStandardContains("R")
 }, sort: \User.name) var users: [User]
 ```
 - Better for real text search since it ignores case. Matches 3 of 4 sample users (anyone with an "r" anywhere in their name).

 **3. Combining conditions with `&&`**
 ```swift
 @Query(filter: #Predicate<User> { user in
     user.name.localizedStandardContains("R") &&
     user.city == "London"
 }, sort: \User.name) var users: [User]
 ```
 - Both sides must be true. Only matches users with an "R" in their name **and** living in London (Ed and Roy in the sample data).

 **4. Same logic using `if`/`else` instead of `&&`**
 ```swift
 @Query(filter: #Predicate<User> { user in
     if user.name.localizedStandardContains("R") {
         if user.city == "London" {
             return true
         } else {
             return false
         }
     } else {
         return false
     }
 }, sort: \User.name) var users: [User]
 ```
 - `#Predicate` supports a limited subset of Swift syntax, including `if`/`else` with `return`, as an alternative to chaining `&&`.

 **Important gotcha:** You **cannot** simplify this by dropping the `else` blocks and falling through to a single `return false` at the end:
 ```swift
 // ❌ This does NOT compile inside #Predicate:
 if user.name.localizedStandardContains("R") {
     if user.city == "London" {
         return true
     }
 }
 return false
 ```
 Even though this looks like valid, simplified Swift logic, it fails — because `#Predicate` isn't actually executing Swift control flow at runtime. It's a macro that rewrites your code into a completely different internal representation used to query the database. Fall-through logic like this isn't supported, even though it "should" work by normal Swift reasoning.

 **Debugging tip:** Right-click `#Predicate` in Xcode and choose **"Expand Macro"** to see the actual generated code — it's dramatically more complex than what you wrote, which explains why some seemingly-equivalent predicate rewrites unexpectedly fail.

 **Takeaway:** `#Predicate` looks like plain Swift but has real restrictions since it compiles to database query logic, not executable code. Stick to the patterns Apple/Paul demonstrate (full `if/else` with explicit `return true`/`return false` in every branch, or `&&`/`||` chains) rather than assuming normal Swift refactoring rules apply.
*/
