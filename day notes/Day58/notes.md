# Day 58 – Project 12, Part 2: SwiftData Summary

Covers: dynamic sorting/filtering with `@Query`, relationships, and CloudKit sync.

---

## 1. Dynamic Sorting & Filtering `@Query`

**Core idea:** `@Query` can't take user input directly. Move the query into its own view, pass values in through an `init`, and build the query with the underscore syntax (`_users = Query(...)`), which accesses the query itself rather than the resulting array.

**Filtering**

```swift
struct UsersView: View {
    @Query var users: [User]

    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }

    var body: some View {
        List(users) { user in Text(user.name) }
    }
}
```

In `ContentView`:

```swift
@State private var showingUpcomingOnly = false
@State private var sortOrder = [
    SortDescriptor(\User.name),
    SortDescriptor(\User.joinDate),
]

UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast,
          sortOrder: sortOrder)
```

- `.now` shows only upcoming joiners; `.distantPast` shows everyone.
- Toolbar button toggles the Boolean; its label shows what pressing it will do next.

**Sorting**

- Use a `Picker` bound to `$sortOrder` and attach a whole `[SortDescriptor]` array to each option with `.tag()`.
  - "Sort by Name" → name, then joinDate
  - "Sort by Join Date" → joinDate, then name
- A bare `Picker` in the toolbar renders inconsistently, so wrap it in a `Menu`:

```swift
Menu("Sort", systemImage: "arrow.up.arrow.down") {
    // Picker goes here
}
```

---

## 2. Relationships

Relationships link models together (e.g. a `User` has many `Job`s). SwiftData builds them automatically once declared.

```swift
@Model class Job {
    var name: String
    var priority: Int
    var owner: User?      // links job -> user
}

// In User:
var jobs = [Job]()        // links user -> jobs
```

Two-way relationships are usually best.

**SwiftData handles for you**

- **Lazy loading:** jobs load only when first accessed.
- **Automatic migration:** adding `jobs` gives existing users an empty array on next launch. Simple migrations are automatic; complex ones need custom migrations.
- **Container:** only `User.self` is needed in `modelContainer()`; `Job` is discovered through the relationship.
- **`@Query`:** unchanged. Just use `user.jobs` like a normal array.

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

| Rule | Behavior |
|------|----------|
| `.nullify` (default) | Deleting a user sets each job's `owner` to `nil`; jobs survive |
| `.cascade` | Deleting a user also deletes all their jobs (and continues down further relationships) |

```swift
@Relationship(deleteRule: .cascade) var jobs = [Job]()
```

---

## 3. Syncing SwiftData with CloudKit

Requires a **paid Apple Developer account**. Without one, none of this works.

**Enable iCloud**

1. Click the app icon in the project navigator, then select your app under **TARGETS**.
2. Open **Signing & Capabilities**.
3. **+ Capability** → **iCloud**.
4. Check **CloudKit**, then press **+** to add a container named `iCloud.` + your bundle ID (e.g. `iCloud.com.hackingwithswift.swiftdatatest`).
5. **+ Capability** → **Background Modes** → check only **Remote Notifications**.

**Model requirements** (not optional)

- All properties must be optional or have default values.
- All relationships must be optional.

```swift
// Job
var name: String = "None"
var priority: Int = 1
var owner: User?

// User
var name: String = "Anonymous"
var city: String = "Unknown"
var joinDate: Date = Date.now
@Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]()
```

If these changes are skipped, sync silently fails. Check the top of Xcode's log for SwiftData warnings.

**Handling optionals**

```swift
user1.jobs?.append(job1)
Text(String(user.jobs?.count ?? 0))

// Cleaner: read-only computed property
var unwrappedJobs: [Job] {
    jobs ?? []
}
```

**Testing:** the simulator is poor at iCloud sync (slow, wrong, or nothing). Use a real device.

---

## Key Takeaways

- Dynamic queries = separate view + custom `init` + underscore-prefixed property access.
- `.tag()` can attach any value, including arrays of `SortDescriptor`, to picker options.
- Declare relationships by using the other model as a property type; use `@Relationship(deleteRule:)` for explicit deletion control.
- Treat SwiftData models like regular `@Observable` classes.
- CloudKit needs: paid developer account, iCloud capability, CloudKit container, Remote Notifications, defaults/optionals on every property, optional relationships.
- Use a computed `unwrappedJobs` to keep optional handling out of your views.
- Test iCloud sync on a real device, not the simulator.
