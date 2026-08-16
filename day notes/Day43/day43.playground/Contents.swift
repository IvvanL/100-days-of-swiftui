// ** DAY 43 NAVIGATION **

// ** THE PROBLEM WITH A SIMPLE NAVIGATIONLINK **

/*
 
 Issue: Using NavigationLink("Title") { DetailView() } directly is easy for simple cases, but it has a hidden performance cost.
 
 What happens:
 
 SwiftUI eagerly creates the destination view instance just by showing the NavigationLink on screen — even if the user never taps it.
 
 This was confirmed by adding a print() statement inside a custom DetailView's init() — the message printed immediately on launch, without tapping anything.
 
 Why it matters:
 
 Fine for one or two links.
 But with dynamic data (e.g. a List of 1000 rows, each with its own NavigationLink), SwiftUI ends up creating many DetailView instances unnecessarily — often multiple times as the user scrolls — wasting performance.
 
 Example that demonstrates the problem:
 
 NavigationStack {
     List(0..<1000) { i in
         NavigationLink("Tap Me") {
             DetailView(number: i)
         }
     }
 }
 
 This triggers repeated, unnecessary view creation for rows that haven't even been tapped.
 
 Solution (to be covered next): Attach a presentation value to the navigation link instead of embedding the destination view directly — a more efficient approach for dynamic/large datasets.

*/

// ** HANDLING NAVIGATION THE SMART WAY WITH NAVIGATIONDESTINATION **

/*
 
 The old (simple) way:
 
 NavigationLink("Tap Me") {
     Text("Detail View")
 }
 
 Works, but SwiftUI eagerly creates the destination view — inefficient for dynamic/large data (see earlier "problem with a simple NavigationLink" notes).
 
 The better way: separate the value from the destination
 
 Two steps:
 1. Attach a value to the NavigationLink (any type — string, int, custom struct — as long as it conforms to Hashable).
 2. Attach .navigationDestination() inside the NavigationStack, telling SwiftUI what view to show for that value.
 Example — list of numbers:
 
 NavigationStack {
     List(0..<100) { i in
         NavigationLink("Select \(i)", value: i)
     }
     .navigationDestination(for: Int.self) { selection in
         Text("You selected \(selection)")
     }
 }
 
 The NavigationLink just carries a value (i) — it doesn't build the destination view directly.
 
 .navigationDestination(for: Int.self) tells SwiftUI: "when someone navigates to an Int, show this view," receiving the value in selection.
 
 Tip: You can add multiple .navigationDestination() modifiers for different data types (e.g. one for Int, one for String).
 
 Why Hashable is required:
 
 Hashing converts data into a smaller, consistent representation (like a "fingerprint") so it can be compared/looked up quickly — used internally by Swift for things like Set.
 
 Most built-in types (Int, String, Date, URL, arrays, dictionaries) already conform to Hashable automatically — no extra work needed.
 
 Making a custom struct Hashable:
 
 struct Student: Hashable {
     var id = UUID()
     var name: String
     var age: Int
 }
 
 Just add Hashable to the struct's protocol list — as long as all its properties are themselves Hashable (which UUID, String, Int all are), Swift auto-generates the conformance for you.
 
 Once conforming, the struct can be used as a navigation value just like Int or String.
 
 Key takeaway: Separating the value from the destination view lets SwiftUI create destination views lazily (only when actually needed), which is much more efficient for dynamic lists than embedding the view directly in the NavigationLink.
*/
