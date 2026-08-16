# Day 44 - Navigation Project 9, part 2

Today's focus: moving beyond basic navigation to **programmatic navigation**, **NavigationPath**, and **persisting navigation state** with Codable.

---

## 1. Programmatic Navigation with NavigationStack
- Instead of relying only on user taps (`NavigationLink`), you can control navigation in code by binding the stack to a path.
- Bind an array to the stack's `path` parameter:
  ```swift
  @State private var path = [Int]()

  NavigationStack(path: $path) {
      ...
  }
  ```
- Appending to `path` programmatically pushes a new view; removing pops it — no user tap required.
- Useful for things like: deep linking, "jump to" buttons, or completing a multi-step flow (checkout, onboarding) and auto-advancing.

---

## 2. Navigating to Different Data Types with NavigationPath
- A plain array path (`[Int]`, `[String]`) only supports **one data type** at a time.
- `NavigationPath` is a type-erased container that lets you push **multiple different Hashable types** onto the same stack.
  ```swift
  @State private var path = NavigationPath()
  ```
- Use `.navigationDestination(for:)` once per type you want to support — SwiftUI matches the right view based on the value's type.
- Trade-off: `NavigationPath` is more flexible but **not directly Codable** (only `Hashable`), which matters for persistence (see #4).

---

## 3. Returning to the Root View Programmatically
- Common need: pop all the way back to the start (e.g., after finishing checkout).
- **Array path:** `path.removeAll()`
- **NavigationPath:** reassign a fresh instance — `path = NavigationPath()` (it has no `removeAll()`, since it isn't a collection)
- If the reset button lives in a subview that doesn't own `path`, share it via `@Binding`:
  ```swift
  @Binding var path: NavigationPath
  ```
  and pass it in at every place the subview is created: `DetailView(number: 0, path: $path)`.
- (Alternative to `@Binding`: store `path` in an external `@Observable` class instead — this is exactly the approach used for persistence below.)

---

## 4. Saving NavigationStack Paths with Codable
Goal: persist the nav path to disk so the app reopens exactly where the user left off.

- Move `path` into an external `@Observable` class (`PathStore`):
  - `didSet` on `path` calls `save()` automatically on every change
  - `init()` loads saved JSON from disk, falling back to an empty path if none exists

**Array path** — straightforward, since `[Int]` is natively `Codable`:
```swift
@Observable
class PathStore {
    var path: [Int] { didSet { save() } }
    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath),
           let decoded = try? JSONDecoder().decode([Int].self, from: data) {
            path = decoded
            return
        }
        path = []
    }

    func save() {
        if let data = try? JSONEncoder().encode(path) {
            try? data.write(to: savePath)
        }
    }
}
```

**NavigationPath** — needs extra steps since it's not directly `Codable`:
- Decode into `NavigationPath.CodableRepresentation`, then wrap: `NavigationPath(decoded)`
- When saving, unwrap via `path.codable` first — this returns `nil` if any element in the path can't be encoded, so guard against that before encoding

```swift
@Observable
class PathStore {
    var path: NavigationPath { didSet { save() } }
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
        if let data = try? JSONEncoder().encode(representation) {
            try? data.write(to: savePath)
        }
    }
}
```

Bind the stack to the store's path instead of local `@State`:
```swift
@State private var pathStore = PathStore()

NavigationStack(path: $pathStore.path) {
    DetailView(number: 0, path: $pathStore.path)
        .navigationDestination(for: Int.self) { i in
            DetailView(number: i, path: $pathStore.path)
        }
}
```

---

## ⚠️ Common Mistakes (from my own debugging today)
- **Type mismatch:** a subview's `@Binding var path` type must exactly match the store's path type (`NavigationPath` vs `[Int]`) — can't mix them.
- **Forgetting to pass the binding:** every place a subview needing `path` is instantiated must receive it (`path: $pathStore.path`), or the code won't compile.
- **Wrong reset call:** `NavigationPath` has no `removeAll()` — must reassign `path = NavigationPath()`.

## 🎯 Key Takeaway
Storing the path in an external `@Observable` class gives you **both** programmatic control (reset, push, pop from anywhere via binding) **and** free persistence (auto-save/load via `Codable`) — so the app can restore a user's exact navigation state even after being closed for days.
