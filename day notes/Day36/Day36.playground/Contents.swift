// ** DAY 36 - iExpense - Project 7, part 1

// ** USING @STATE WITH CLASSES **

// @State with classes VS structs
// + @State works perfectly with structs - when any property changes, Swift creates a whole new struct, which @State detects and triggers a UI refresh
// + @State does not work with classes by default - when a class property changes, the class instance itself doesnt change, so @State doesnt notice anything andf the UI wont update
// + to fix this, add @Observable before the class definition. this tells SwiftUI to watch the individual properties inside the class for changes instead.
// + They key practical difference: use classes when you need to SHARE DATA BETWEEN MULTIPLE VIEWS (they all point to the same instance). Use structs when date is LOCAL TO ONE VIEW.

// ** SHARING SWIFTUI STATE WITH @OBSERVABLE **

// @Observable - Sharing state with classes in SwiftUI
// - by default @State only auto-updates views when used with structs. For classes, you need to add the @observable macro to get the same behavior
// @Observable
// class User {
//  var firstName = "Bilbo"
//  var lastName = "Baggins"
//  }

// - what @Observable does under the hood:
//  + marks each property with @ObservationTracked, which wathes every read/write
//  + makes the class conform to the @Observable protocol, which SwiftUI looks for
//  + IOS tracks which views read which properties, so only affected views re-render

// - @State bnehaves differently depending on the type:
//  + Struct -> @State keeps it alive and watches for changes
//  + Class -> @State only keeps it alive; @Observable handles the change tracking

// ** SHOWING AND HIDING VIEWS **

// - a sheet presents a new view on top of the current one (slides up from the bottom on IOS)

// 4 steps to show a sheet:
//  1. add a Bool state property: @State private var showingSheet = false
//  2. Toggle it on button tap: showingSheet.toggle()
//  3. attach the .sheet modifier to your view
//  4. Define what goes inside the sheet

/*
 struct ContentView: View {
     @State private var showingSheet = false

     var body: some View {
         Button("Show Sheet") {
             showingSheet.toggle()
         }
         .sheet(isPresented: $showingSheet) {
             SecondView()
         }
     }
 }
 */

// - Passing data into a sheet: Just pass paremeters normally when initializing the view inside the sheet - Swift will enforce that all required values are provided

// - Dismissing programmatically: Use @Environment(\.dismiss) inside the presented view and call dismiss():

/*
 @Environment(\.dismiss) var dismiss

 Button("Dismiss") {
     dismiss()
 }
 */

// - this works regardless of how the view was presented - SwiftUI figures out the right dismissal method automatically

// ** DELETING ITEMS USING onDELETE() **

/*
 import SwiftUI

 struct ContentView: View {
     @State private var numbers = [Int]()
     @State private var currentNumber = 1
     
     var body: some View {
         NavigationStack {
             VStack {
                 List {
                     ForEach(numbers, id: \.self) {
                         Text("Row \($0)")
                     }
                     .onDelete(perform: removeRows)
                 }
                 
                 Button("Add number") {
                     numbers.append(currentNumber)
                     currentNumber += 1
                 }
             }
             .toolbar {
                 EditButton()
             }
         }
     }
     
     func removeRows(at offsets: IndexSet) {
         numbers.remove(atOffsets: offsets)
     }
 }
     

 #Preview {
     ContentView()
 }
 */

// - onDelete() - lets users swipe-to-delete rows in a list. It must be attached to a ForEach, not directly to a list.

// setup:
//  1. use ForEach inside your List (required - onDelete only exists on ForEach)
//  2. create a method that takes an IndexSet and removes those items from you array
//  3. attach .onDelete(perform:) to the ForEach

/*
 ForEach(numbers, id: \.self) {
     Text("Row \($0)")
 }
 .onDelete(perform: removeRows)

 func removeRows(at offsets: IndexSet) {
     numbers.remove(atOffsets: offsets)
 }
 */

// - Bonus - Edit/Done Button:
//  + wrap your view in a NavigationStack and add this to get a built-in edit mode that lets users delete multiple rows at once:

// .toolbar {
//      EditButton()
//  }

// - key quirk: even if your list is entirely dynamic, you still need ForEach inside List to use onDelete(). the upside is that this makes it easy to have lists where only some rows are deletable

// ** STORING USER SETTINGS WITH UserDefaults **

/*
 import SwiftUI

 struct ContentView: View {
     @AppStorage("Tap Count") private var tapCount = 0
     
     var body: some View {
         Button("Tap count: \(tapCount)") {
             tapCount += 1
         }
     }
 }
     

 #Preview {
     ContentView()
 }

 */

/*
 
 - Storing User Settings with UserDefaults & @AppStorage:
 - UserDefaults is a simple key-value store for small user preferences (aim for under 512KB). Everything stored there loads automatically at app launch, so don't overuse it.
 
 Raw UserDefaults usage:
 
 // Write
 UserDefaults.standard.set(tapCount, forKey: "Tap")

 // Read
 @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
 
 Cleaner approach — @AppStorage: Acts like @State but automatically reads/writes to UserDefaults:
 
 @AppStorage("tapCount") private var tapCount = 0
 
 - The string is the key, and the assigned value is the default if no saved value exists yet.
 
 - Key things to know:
    + Missing keys return a zero-value (0, false, "") — not an error
    + iOS batches writes, so there's a short delay before data is permanently saved (but won't lose data on normal app termination)
    + @AppStorage works great for primitives (Int, Bool, String) but doesn't easily support complex types like structs
    + Apple requires you to disclose UserDefaults/@AppStorage usage when submitting to the App Store
 
 Rule of thumb: Use @AppStorage for simple preferences, and reach for a proper database (SwiftData, CoreData) for anything more complex.
 */
