# Day 59 – Project 12, Part 3: Challenge

Three challenges that build on project 7 (iExpense):

- [x] **Challenge 1:** Upgrade to SwiftData [COMPLETED]
- [ ] **Challenge 2:** Add a customizable sort order (by name or by amount)
- [ ] **Challenge 3:** Add a filter option (all, just Personal, just Business)

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

**3. Read and delete in `ContentView`**

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

---

## Final code

### `Day59App.swift`

```swift
import SwiftData
import SwiftUI

@main
struct Day59App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
```

### `ContentView.swift`

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
    @Query var expenses: [ExpenseItem]
    @Environment(\.modelContext) var modelContext

    @State private var showingAddExpense = false

    var body: some View {
        NavigationStack {
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
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView()
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
    ContentView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

### `AddView.swift`

```swift
import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    let types = ["Business", "Personal"]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    modelContext.insert(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView()
        .modelContainer(for: ExpenseItem.self, inMemory: true)
}
```

---

## What I learned

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

## Up next

### Challenge 2: Sort order

