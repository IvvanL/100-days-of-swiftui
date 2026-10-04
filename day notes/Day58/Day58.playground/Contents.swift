// ** DAY 58 - Project 12 part 2

// ** DYNAMICALLY SORTING AND FILTERING @QUERY WITH SWIFTUI **

/*
 **Core idea:** `@Query` can't take user input directly, so you move the query into its own view and pass values in through an initializer. The initializer builds the query using the underscore syntax (`_users = Query(...)`), which accesses the query itself rather than the resulting array.

 ## Filtering

 1. **Create `UsersView`** (imports `SwiftData` and `SwiftUI`) that holds `@Query var users: [User]` and shows a `List` of user names.
 2. **Add an initializer** that takes a minimum join date:
    ```swift
    init(minimumJoinDate: Date) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: \User.name)
    }
    ```
 3. **In `ContentView`:** remove the old `@Query`, add `@State private var showingUpcomingOnly = false`, and replace the list with:
    ```swift
    UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast)
    ```
    `.now` shows only future joiners; `.distantPast` shows everyone.
 4. **Add a toolbar button** that toggles the Boolean, with a label that reflects what pressing it will do next ("Show Everyone" / "Show Upcoming").

 ## Sorting

 1. **Update the initializer** to also accept `sortOrder: [SortDescriptor<User>]` and pass it to `Query(..., sort: sortOrder)`. (Update the preview too.)
 2. **In `ContentView`,** add a `@State` array of sort descriptors (default: name, then join date) and pass it into `UsersView`.
 3. **Add a `Picker`** bound to `$sortOrder`. Use `.tag()` to attach a whole `[SortDescriptor]` array to each option:
    - "Sort by Name" → name, then joinDate
    - "Sort by Join Date" → joinDate, then name

 ## Menu tip

 A bare `Picker` in the toolbar renders inconsistently across devices (either a three-dots button or just the current selection in the nav bar). Wrapping it in a `Menu` gives a cleaner result:
 ```swift
 Menu("Sort", systemImage: "arrow.up.arrow.down") {
     // Picker goes here
 }
 ```

 ## Key takeaways
 - Dynamic queries require a separate view + custom `init` + underscore-prefixed property access.
 - Pass simple values (a date, a sort array) from the parent view into the child's initializer.
 - `.tag()` lets you attach any value, including arrays of `SortDescriptor`, to picker options.
 - Use `Menu` to wrap pickers/buttons in the navigation bar.

*/

// **  RELATIONSHIPS WITH SWIFTDATA, SWIFTUI AND @QUERY **

/*
 **What:** Relationships link models together (e.g. a `User` has many `Job`s). SwiftData sets them up automatically once you declare them in your model code.

 **Setup**
 - `Job` model gets `var owner: User?` (links job to user)
 - `User` model gets `var jobs = [Job]()` (links user to jobs)
 - Two-way relationships are usually best, since they make data easier to work with

 **What SwiftData handles for you**
 - **Lazy loading:** jobs load only when first accessed
 - **Automatic migration:** adding `jobs` to `User` silently gives existing users an empty array on next launch (simple migrations are automatic; complex ones need custom migrations)
 - **Container:** only `User.self` is needed in `modelContainer()`, since `Job` is discovered through the relationship
 - **`@Query`:** unchanged; just use `user.jobs` like a normal array

 **Sample data**
 ```swift
 @Environment(\.modelContext) var modelContext

 func addSample() {
     let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
     let job1 = Job(name: "Organize sock drawer", priority: 3)
     modelContext.insert(user1)
     user1.jobs.append(job1)
 }
 ```
 Only the user needs `insert`; appended jobs are tracked through the relationship.

 **Delete rules**
 - Default: deleting a `User` leaves their jobs in the database (no surprise data loss)
 - `.nullify` (default): job's `owner` becomes `nil`
 - `.cascade`: deleting a user also deletes all their jobs (and continues down further relationships)

 ```swift
 @Relationship(deleteRule: .cascade) var jobs = [Job]()
 ```

 **Key takeaways**
 - Treat SwiftData models like regular `@Observable` classes
 - Declare relationships by using the other model as a property type
 - Use `@Relationship(deleteRule:)` when you want explicit control over deletion
*/

// ** SYNCING SWIFTDATA WITH CLOUDKIT **

/*
 **What:** SwiftData can sync user data to iCloud, often with almost no code. It **requires a paid Apple Developer account**; without one, none of this works.

 ## Enabling iCloud

 1. Click the app icon at the top of the project navigator, then select your app under **TARGETS**.
 2. Open the **Signing & Capabilities** tab.
 3. Press **+ Capability** and add **iCloud**.
 4. Check **CloudKit**, then press **+** to add a CloudKit container. Name it with `iCloud.` plus your bundle ID, e.g. `iCloud.com.hackingwithswift.swiftdatatest`.
 5. Press **+ Capability** again and add **Background Modes**, then check only **Remote Notifications** (lets the app know when iCloud data changes so it can sync locally).

 ## Model requirements

 iCloud sync has rules that local-only SwiftData doesn't. They are requirements, not suggestions.

 - **All properties must be optional or have default values.**
 - **All relationships must be optional.** This is the more disruptive rule.

 Updated `Job`:
 ```swift
 var name: String = "None"
 var priority: Int = 1
 var owner: User?
 ```

 Updated `User`:
 ```swift
 var name: String = "Anonymous"
 var city: String = "Unknown"
 var joinDate: Date = Date.now
 @Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]()
 ```

 If you skip these changes, sync silently fails. Check the top of Xcode's log, where SwiftData should warn about properties that break syncing.

 ## Handling optionals in your code

 - Adding jobs: `user1.jobs?.append(job1)`
 - Reading the count: `Text(String(user.jobs?.count ?? 0))`
 - **Cleaner approach:** add a read-only computed property so you don't scatter optional chaining everywhere:
 ```swift
 var unwrappedJobs: [Job] {
     jobs ?? []
 }
 ```
 Read-only prevents accidentally trying to modify a missing array.

 ## Testing

 The simulator is fine for local SwiftData but **poor at testing iCloud**. Data may sync slowly, incorrectly, or not at all. Use a **real device**.

 ## Key takeaways
 - Paid developer account + iCloud capability + CloudKit container + Remote Notifications are all required.
 - Every property needs a default or must be optional; relationships must be optional.
 - Use a computed `unwrappedJobs` property to keep code clean.
 - Test sync on a real device, not the simulator.
*/
