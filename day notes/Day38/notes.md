# Day 38 - IExpense  Project 7, part 3 Challenge- complete

Notes from the Day 38 challenge project (iExpense), covering three extensions to the base app: currency localization, conditional styling, and sectioned lists with correct deletion handling.

- [Challenge 1: User's Preferred Currency]
- [Challenge 2: Style Amounts Based on Value]
- [Challenge 3: Split into Personal / Business Sections]

---

## Challenge 1: User's Preferred Currency

> Use the user's preferred currency, rather than always using US dollars.

Replaced the hardcoded `USD` currency code with the device's actual locale-based currency.

```swift
Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
```

**Key takeaways:**

- `Locale.current` reflects the device's region settings.
- `.currency?.identifier` extracts the ISO currency code (e.g. `GBP`, `JPY`) tied to that region.
- `?? "USD"` is a safe fallback in case the currency can't be determined.
- Applied identically in `AddView`'s `TextField` for consistency.

---

## Challenge 2: Style Amounts Based on Value

> Expenses under $10 should have one style, under $100 another, and over $100 a third.

Added a computed property on the model to determine color based on amount:

```swift
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
```

Applied in the view:

```swift
Text(item.amount, format: ...)
    .foregroundStyle(item.amountColor)
```

**Key takeaways:**

- `switch` can match numeric **ranges** directly (`0..<10`) — cleaner than chained `if/else` for tiered logic.
- Putting `amountColor` on the **model** (`ExpenseItem`) instead of the view keeps `body` focused on layout and makes the logic reusable anywhere the model is used.

---

## Challenge 3: Split into Personal / Business Sections

> Split the expenses list into two sections. This is tricky because of how items are deleted.

### Grouping with `Section`

```swift
Section("Personal") {
    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
        // row content
    }
}
```

`.filter()` narrows the full array down to just the items relevant to that section.

### The Deletion Bug

`.onDelete(perform:)` provides an `IndexSet` of **positions within whatever array the `ForEach` loops over** — the *filtered* array, not the full `expenses.items` array.

Applying those offsets directly to the full array deletes the **wrong item**, since the same numeric position points to a different item depending on which array is indexed.

**Example:**

| Index | Full array (`expenses.items`) | Filtered "Business" array |
|:-----:|-------------------------------|----------------------------|
| 0     | Coffee (Personal)              | Laptop                     |
| 1     | Laptop (Business)               | Software                   |
| 2     | Lunch (Personal)                |                             |
| 3     | Software (Business)             |                             |

Swiping to delete **Software** (position `1` in the filtered array) but calling `remove(atOffsets: [1])` on the full array deletes **Laptop** instead.

### The Fix

```swift
func removeItems(at offsets: IndexSet, from type: String) {
    let filteredItems = expenses.items.filter { $0.type == type }
    let itemsToDelete = offsets.map { filteredItems[$0] }

    expenses.items.removeAll(where: { item in
        itemsToDelete.contains(where: { $0.id == item.id })
    })
}
```

1. Rebuild the same filtered array shown in that section.
2. Convert `IndexSet` offsets into actual `ExpenseItem`s using `.map` — `Array` can't be subscripted directly with an `IndexSet` (`filteredItems[offsets]` fails to compile).
3. Remove matching items from the **real** array by comparing `id` (via `Identifiable`), not position.

### Wiring Up `.onDelete`

Since `removeItems` now takes two arguments but `.onDelete(perform:)` only auto-passes one, a closure is used instead:

```swift
.onDelete { offsets in
    removeItems(at: offsets, from: "Personal")
}
```

Each section passes its own `type`, so deletions always resolve against the correct filtered context.

**Key takeaways:**

- Filtered views of an array must be reconciled with the source array by **identity (`id`)**, not position. This pattern recurs constantly — search results, tabs, filtered tables.
- `Array` can't be subscripted directly with an `IndexSet` — use `.map { array[$0] }` to convert offsets into elements one at a time.
- Mismatched braces can produce **misleading compiler errors** far from the actual mistake. When an error doesn't make sense, check brace-matching first.

---

## Summary

| Challenge | Core Concept |
|---|---|
| 1. Currency | `Locale.current` reflects the device's region/currency automatically |
| 2. Styling | `switch` on ranges + computed properties on the model |
| 3. Sections | Filtered arrays require identity-based (`id`) deletion, not position-based |
