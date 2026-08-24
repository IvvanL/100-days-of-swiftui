// ** DAY 47 Milestone Project, 7-9 Recap **

// WHAT I LEARNED

/*
 *State & Data:*
 - `@State` works with structs; `@Observable` handles data in classes
 - Reading/writing with `UserDefaults`
 - Archiving/unarchiving with `Codable` (including nested/hierarchical data)
 - `Identifiable` protocol for unique UI item identification

 *Views & Navigation:*
 - `sheet()` modifier + `dismiss` environment key for presenting/dismissing views
 - `NavigationLink` to push views onto the navigation stack
 - Programmatic navigation using the type-erased `NavigationPath`
 - Customizing navigation bar appearance
 - Precise toolbar item placement

 *Lists & Interaction:*
 - `onDelete(perform:)` for swipe-to-delete
 - `EditButton` for easier list editing

 *Layout:*
 - `containerRelativeFrame()` to fit content to screen
 - `ScrollView` for custom scrollable layouts

 *Language Features:*
 - Generics for writing methods that work across different data types

 **Takeaway:** Broad range — from core language features (generics, protocols) to user-facing UI work — with two new SwiftUI projects built as a result.
*/

// KEY CONCEPTS

/*
 **Key Points — Deep Dive**

 **1. Classes vs Structs (Value vs Reference Types)**
 - Structs are **value types**: data is stored directly in the variable.
 - Classes are **reference types**: the variable holds a "signpost" pointing to memory where the data actually lives.
 - Sharing a class instance across variables means they all point to (and can modify) the *same* data; structs each get their own independent copy.
 - Constants behave differently for each:
   - `let` class instance = constant signpost (can't repoint to a different object), but its *properties* can still change unless they're also `let`.
   - `let` struct instance = the whole value is locked, including all properties.
 - In UIKit (no `@State`-style auto-updating), sharing class instances across views could cause UI to get out of sync — so UIKit devs often used structs for data and classes for views. SwiftUI flips this: classes (`@Observable`) for shared data, structs for views.

 **2. Using UserDefaults Wisely**
 - Best for **small** amounts of data (rule of thumb: under ~512KB).
 - Only natively supports strings, numbers, dates, URLs, binary data, and arrays/dictionaries of those (same types a plist supports) — anything else needs `Codable` conversion first.
 - UserDefaults is literally backed by a property list file — so treat it like Info.plist: good for small config/state, not bulk data storage.
 - Intended purpose: storing an app's *default* settings/state at launch, not general-purpose data storage.

 **3. When to Use Generics**
 - Best practice: write a **concrete/non-generic** version first (e.g., a method that decodes one specific type), then generalize later if needed.
 - Protocols like `Comparable` don't mean two different conforming types can be compared to each other — conformance only guarantees comparison *within* the same type.
 - You can't return a bare protocol type (e.g., `-> Comparable`) because it lacks enough concrete meaning.
 - **Generic constraints** (e.g., requiring `Codable`) narrow what types are allowed but *unlock* more functionality (like being able to use `JSONDecoder`).
 - Rule of thumb: avoid generics until you need them, and when you do, add constraints to maximize usefulness.
*/
