# Day 59 – Project 12, Part 3: Challenge [Completed]

Three challenges that build on project 7 (iExpense):

- [x] **Challenge 1:** Upgrade to SwiftData
- [x] **Challenge 2:** Add a customizable sort order (by name or by amount)
- [x] **Challenge 3:** Add a filter option (all, just Personal, just Business)

---

## Challenge 1: Upgrade to SwiftData

### Goal

Replace the hand-rolled `Expenses` class (JSON encoding into `UserDefaults`) with SwiftData, which handles saving, loading, and change tracking for you.

### What got replaced

| Before | After |
|---|---|
| `struct ExpenseItem: Identifiable, Codable` | `@Model class ExpenseItem` |
| `@Observable class Expenses` with `didSet` saving to `UserDefaults` | Deleted entirely |
| `@State private var expenses = Expenses()` | `@Query var expenses: [ExpenseItem]` |
| `expenses.items.append(item)` | `modelContext.insert(item)` |
| `expenses.items.removeAll(where:)` | `modelContext.delete(item)` in a loop |
| Passing `expenses` into `AddView` | `AddView` reads `modelContext` from the environment |

### Steps

**1. Convert the model**

- Add `import SwiftData`.
- Put `@Model` on the type and change `struct` to `class` (`@Model` only works on classes).
- Remove `Identifiable` and `Codable`. `@Model` already provides identity, and SwiftData does the storing, so the JSON encoding isn't needed.
- Remove the `id` property.
- Change `let` properties to `var`.
- Write an explicit `init`, because classes don't get a free memberwise initializer. Use `self.name = name` so the property is assigned, not a new local variable.

**2. Create the model container** (in the `App` struct)

```swift
WindowGroup {
    ContentView()
}
.modelContainer(for: ExpenseItem.self)
```

It goes on the scene so every view underneath can reach the same storage. The argument is the `@Model` type with `.self` on the end.

**3. Read and delete**

- `@Query var expenses: [ExpenseItem]` fetches the data and keeps the view updated. There's no `= ...`, because `@Query` fills it in.
- `@Environment(\.modelContext) var modelContext` is how you write and delete.
- `expenses` is now the array itself, so `expenses.items.filter` becomes `expenses.filter`.
- `modelContext.delete(_:)` removes one object, so deleting several needs a `for` loop.

**4. Insert in `AddView`**

- Remove the `expenses` parameter.
- Add `@Environment(\.modelContext) var modelContext`.
- Replace the append with `modelContext.insert(item)`.
- Add `import SwiftData` (needed for `insert` and `.modelContainer`).

**5. Fix the previews**

Any preview of a view that uses SwiftData needs its own container. `inMemory: true` keeps previews from touching real data.

### What I learned

- `@Model` only works on **classes**, and it replaces both `Identifiable` and `Codable` for stored data.
- Inside an `init`, use `self.property = parameter`. Writing `var name = name` just creates a throwaway local variable.
- `.modelContainer(for:)` goes on the scene, and it takes the **model type** (`ExpenseItem.self`), not the view or the project name.
- `@Query` supplies its own value, so there is no `=` after it.
- `modelContext.delete(_:)` takes **one** object, so use a `for` loop for several.
- A file needs `import SwiftData` if it uses `modelContext.insert` or `.modelContainer`, even if it never mentions `@Model`.
- Previews of SwiftData views need `.modelContainer(for:inMemory:)`.
- Old data saved in `UserDefaults` doesn't carry over, which is expected for this challenge.
- Stale Xcode errors can show up after big changes. **Clean Build Folder** (Cmd+Shift+K) then build (Cmd+B) fixes it.
- Select all and press **Ctrl+I** to re-indent. Misaligned code usually points at a brace problem.

---

## Challenge 2: Sort order (by name or amount)

### Goal

Let the user switch between sorting by name and sorting by amount while the app is running.

### The problem

`@Query(sort: ...)` is fixed when a view is created, so a `@Query` sitting in `ContentView` can't react to a sort choice that changes later.

### The solution

1. `ContentView` holds the sort choice in `@State` and shows a menu to change it.
2. The list moves into its own view, `ExpensesListView`, which **receives the sort order as an input**.
3. That view's `init` builds its own query with that sort. When `sortOrder` changes, SwiftUI recreates the view, which builds a fresh query.

### Steps

**1. Hold the choice and add a control**

- One `@State` property holds the current sort: `@State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]`.
- A `Menu` containing a `Picker` goes in the toolbar. Each option has a `.tag` holding an array of sort descriptors.
- The tag's type must match the type of `sortOrder`, which is an **array** of `SortDescriptor`.

**2. Move the list into a new view**

- Create `ExpensesListView` with the `@Query`, the `modelContext`, the `List`, and `removeItems`.
- `ContentView` keeps only `showingAddExpense`, `sortOrder`, the navigation, the toolbar, and the sheet.

**3. Build the query in `init`**

```swift
init(sortOrder: [SortDescriptor<ExpenseItem>]) {
    _expenses = Query(sort: sortOrder)
}
```

**4. Connect them**

`ContentView` creates `ExpensesListView(sortOrder: sortOrder)` and the toolbar, title, and sheet attach to it.

### Final code

`Day59App.swift` and `AddView.swift` are unchanged from Challenge 1.

#### `ContentView.swift`

```swift
import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double

    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }

    var amountColor: Color {
        switch amount {
        case 0..<10:
            return .green
        case 10..<100:
            return .orange
        default:
            return .red
        }
    }
}

struct ContentView: View {
    @State private var showingAddExpense = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]

    var body: some View {
        NavigationStack {
            ExpensesListView(sortOrder: sortOrder)
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense = true
                    }

                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort by", selection: $sortOrder) {
                            Text("Name")
                                .tag([SortDescriptor(\ExpenseItem.name)])

                            Text("Amount")
                                .tag([SortDescriptor(\ExpenseItem.amount)])
                        }
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView()
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

#### `ExpensesListView.swift`

```swift
import SwiftData
import SwiftUI

struct ExpensesListView: View {
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext

    init(sortOrder: [SortDescriptor<ExpenseItem>]) {
        _expenses = Query(sort: sortOrder)
    }

    var body: some View {
        List {
            Section("Personal") {
                ForEach(expenses.filter { $0.type == "Personal" }) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)

                            Text(item.type)
                        }

                        Spacer()

                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(item.amountColor)
                    }
                }
                .onDelete { offsets in
                    removeItems(at: offsets, from: "Personal")
                }
            }

            Section("Business") {
                ForEach(expenses.filter { $0.type == "Business" }) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)

                            Text(item.type)
                        }

                        Spacer()

                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(item.amountColor)
                    }
                }
                .onDelete { offsets in
                    removeItems(at: offsets, from: "Business")
                }
            }
        }
    }

    func removeItems(at offsets: IndexSet, from type: String) {
        let filteredItems = expenses.filter { $0.type == type }
        let itemsToDelete = offsets.map { filteredItems[$0] }

        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesListView(sortOrder: [SortDescriptor(\ExpenseItem.name)])
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

### What I learned

- A `@Query`'s sort is set when the view is created. To change it at runtime, put the query in a **smaller view that takes the sort as a parameter**, so SwiftUI rebuilds that view when the choice changes.
- `@Query var expenses` creates a hidden property called `_expenses`. `expenses` is the **array of results**. `_expenses` is the **`Query` itself**, which does the fetching and sorting. In an `init`, assign to `_expenses` to change how the data is fetched.
- The init parameter type is `[SortDescriptor<ExpenseItem>]`.
- A key path needs the backslash: `\ExpenseItem.name` points at the property. Without it, Swift reads `ExpenseItem.name` as the property on the class itself and gives errors like "Instance member cannot be used on type".
- `\ExpenseItem.self` means the whole object, not a property, so it has nothing to sort by.
- A `Picker`'s `.tag` values must be the **same type** as its `selection`. Here that's an array of `SortDescriptor`.
- A property can only be declared once. `sortOrder` is one box holding the **current** choice, and the picker swaps what's in it.
- A wrong SF Symbol name doesn't cause a compile error. The icon just doesn't appear, so check the spelling when an icon is missing.
- When a view moves, everything that uses its `@Query` or `modelContext` has to move with it, including helper functions like `removeItems`.
- Previews of views with a required `init` parameter need that argument, plus a model container.

---

## Challenge 3: Filter (all, Personal, Business)

### Goal

Let the user show all expenses, only Personal expenses, or only Business expenses.

### The solution

It's the same pattern as Challenge 2, plus one new piece (the predicate):

1. `ContentView` holds the filter choice in `@State` and shows a second menu to change it.
2. The choice is passed into `ExpensesListView` through its `init`.
3. The `init` uses it in the query with a `#Predicate`.
4. Each section hides itself when it has no expenses.

### Steps

**1. Hold the choice and add a control**

- `@State private var filter = "All"` holds the current choice as a plain `String`.
- A second `Menu` with its own icon holds a `Picker` with three options.
- Each `.tag` is a plain string matching the `selection` type, and the spelling matches what `AddView` saves (`"Personal"` and `"Business"` with capital letters).

**2. Pass it in**

`ExpensesListView`'s `init` takes a `filter: String` parameter, and `ContentView` passes `filter: filter`. Every call to the `init` needs the new argument, including the `#Preview`.

**3. Use it in the query**

```swift
init(sortOrder: [SortDescriptor<ExpenseItem>], filter: String) {
    _expenses = Query(filter: #Predicate<ExpenseItem> {
        filter == "All" || $0.type == filter
    }, sort: sortOrder)
}
```

The predicate answers "should this expense be shown?" It is true when the filter is "All", **or** when the expense's type equals the filter.

**4. Hide empty sections**

Two computed properties hold each filtered list once, and each `Section` is wrapped in `if !list.isEmpty`.

### Final code

`Day59App.swift` and `AddView.swift` are unchanged from Challenge 1.

#### `ContentView.swift`

```swift
import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double

    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }

    var amountColor: Color {
        switch amount {
        case 0..<10:
            return .green
        case 10..<100:
            return .orange
        default:
            return .red
        }
    }
}

struct ContentView: View {
    @State private var showingAddExpense = false
    @State private var sortOrder = [SortDescriptor(\ExpenseItem.name)]
    @State private var filter = "All"

    var body: some View {
        NavigationStack {
            ExpensesListView(sortOrder: sortOrder, filter: filter)
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense = true
                    }

                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort by", selection: $sortOrder) {
                            Text("Name")
                                .tag([SortDescriptor(\ExpenseItem.name)])

                            Text("Amount")
                                .tag([SortDescriptor(\ExpenseItem.amount)])
                        }
                    }

                    Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                        Picker("Filter by", selection: $filter) {
                            Text("All").tag("All")
                            Text("Business").tag("Business")
                            Text("Personal").tag("Personal")
                        }
                    }
                }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

#### `ExpensesListView.swift`

```swift
import SwiftData
import SwiftUI

struct ExpensesListView: View {
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext

    init(sortOrder: [SortDescriptor<ExpenseItem>], filter: String) {
        _expenses = Query(filter: #Predicate<ExpenseItem> {
            filter == "All" || $0.type == filter
        }, sort: sortOrder)
    }

    var personalExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Personal" }
    }

    var businessExpenses: [ExpenseItem] {
        expenses.filter { $0.type == "Business" }
    }

    var body: some View {
        List {
            if !personalExpenses.isEmpty {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)

                                Text(item.type)
                            }

                            Spacer()

                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amountColor)
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Personal")
                    }
                }
            }

            if !businessExpenses.isEmpty {
                Section("Business") {
                    ForEach(businessExpenses) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)

                                Text(item.type)
                            }

                            Spacer()

                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(item.amountColor)
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, from: "Business")
                    }
                }
            }
        }
    }

    func removeItems(at offsets: IndexSet, from type: String) {
        let filteredItems = expenses.filter { $0.type == type }
        let itemsToDelete = offsets.map { filteredItems[$0] }

        for item in itemsToDelete {
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesListView(sortOrder: [SortDescriptor(\ExpenseItem.name)], filter: "All")
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

### What I learned

- A `Picker`'s `.tag` must be the **same type** as its `selection`. For sorting that was an array of `SortDescriptor`, and here it's a plain `String`. Key paths are for sorting, because a sort has to point at a property. Picking one of three words doesn't need one.
- Strings have to match exactly. The tags must be spelled like the values `AddView` saves, or the predicate won't match anything.
- `Query` takes `filter:` (a `#Predicate`) as well as `sort:`, and `filter:` comes first.
- A `#Predicate` is **one true/false expression**, not a function body. No `if` and no `return`.
- Use `==` for an exact match. `contains` matches partial text, which is looser than what's needed.
- `||` means "or". `filter == "All" || $0.type == filter` shows everything for "All", and only matching types otherwise.
- Inside a predicate, stick to the `init` parameters and the model's stored properties. Avoid helper functions and computed properties like `amountColor`.
- Adding a parameter to an `init` breaks every call to it, including the `#Preview`.
- A `Section` can be wrapped in an `if` inside a `List`, and `!list.isEmpty` hides it when there's nothing to show.
- Computed properties like `personalExpenses` hold a filtered list once, so the `if` and the `ForEach` don't repeat the same `.filter` call.
