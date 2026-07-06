// ** DAY 37 - iExpense - Project 7, part 2

// ** BUILDING A LIST WE CAN DELETE FROM **

/*
 
 import SwiftUI

 struct ExpenseItem {
     let name: String
     let type: String
     let amount: Double
 }

 @Observable
 class Expenses {
     var items = [ExpenseItem]()
 }

 struct ContentView: View {
     @State private var expenses = Expenses()
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(expenses.items, id: \.name) { item in
                     Text(item.name)
                 }
                 .onDelete(perform: removeItems)
             }
             .navigationTitle("iExpense")
             .toolbar {
                 Button("Add Expense", systemImage: "plus") {
                     let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                     expenses.items.append(expense)
                 }
             }
         }
     }
     
     func removeItems(at offsets: IndexSet) {
         expenses.items.remove(atOffsets: offsets)
     }
 }

 #Preview {
     ContentView()
 }
 */

/*
 
 Goal: Build an expense-tracking list backed by a class (not a plain @State array), so it can later save/load itself automatically.
 
 1. Model a single expense:
 swiftstruct ExpenseItem {
     let name: String
     let type: String
     let amount: Double
 }
 
 2. Store the array in an @Observable class:
 swift@Observable
 class Expenses {
     var items = [ExpenseItem]()
 }

 @Observable lets SwiftUI watch the class for changes.

 3. Use it in the view:
 swift@State private var expenses = Expenses()

 @State keeps the object alive; @Observable is what makes SwiftUI actually react to changes in it.

 4. Display with List + ForEach (using ForEach instead of a plain List so you get access to .onDelete()):
 swiftNavigationStack {
     List {
         ForEach(expenses.items, id: \.name) { item in
             Text(item.name)
         }
     }
     .navigationTitle("iExpense")
 }
 
 5. Add test data via toolbar button:
 swift.toolbar {
     Button("Add Expense", systemImage: "plus") {
         let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
         expenses.items.append(expense)
     }
 }
 
 6. Enable swipe-to-delete:
 swiftfunc removeItems(at offsets: IndexSet) {
     expenses.items.remove(atOffsets: offsets)
 }
 swiftForEach(expenses.items, id: \.name) { item in
     Text(item.name)
 }
 .onDelete(perform: removeItems)
 
 
 */


// ** WORKING WITH IDENTIFIABLE ITEMS IN SWIFT UI **

/*
 struct ExpenseItem: Identifiable {
     let id = UUID()
     let name: String
     let type: String
     let amount: Double
 }

 @Observable
 class Expenses {
     var items = [ExpenseItem]()
 }

 struct ContentView: View {
     @State private var expenses = Expenses()
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(expenses.items) { item in
                     Text(item.name)
                 }
                 .onDelete(perform: removeItems)
             }
             .navigationTitle("iExpense")
             .toolbar {
                 Button("Add Expense", systemImage: "plus") {
                     let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                     expenses.items.append(expense)
                 }
             }
         }
     }
     
     func removeItems(at offsets: IndexSet) {
         expenses.items.remove(atOffsets: offsets)
     }
 }

 #Preview {
     ContentView()
 }

 */

// - the problem: ForEach/List need a way to uniquely identify each item so SwiftUI can track what changed (for animations, deletions, etc)
// - Using:

// ForEach(expenses.items, id: \.name) { item in ... }

// this breaks when names arent unique - ex. tapping "add expense" repeatedly creates multiple items all named "Test"

// when one is deleted , SwiftUI sees [Test, test, test, test] -> [Test, test, test] and cant reliably tell which one was removed.
//  + this is a logic error not a creash - the code runs but the identifier isnt actually unique like you claimed.
//  + Combining name + Type + amount into a computed property doesnt really fix it either - still not guarantedd unique

// The fix: UUID
//  + UUID  = "Universally unique identifier" - a long hex string, virtually guaranteed to never repeat
//  + add it as a property, letting Swift auto-generate it so you never manage IDs manually:

/*
 struct ExpenseItem {
     let id = UUID()
     let name: String
     let type: String
     let amount: Double
 }
 */

// - update the ForEach to identify by id instead of name:

/*
 ForEach(expenses.items, id: \.id) { item in
     Text(item.name)
 }
 */

// - now deletions animate correctly because SwiftUI can pinpoint exactly which item changed

// Going further: conform to Identifiable

/*
 struct ExpenseItem: Identifiable {
     let id = UUID()
     let name: String
     let type: String
     let amount: Double
 }
 
 */

// - identifiable is a built in protocol requiring only one thing: a property called id thats unique. Since we already have that, conformance is free.
// - Benefit: Once a type is Identifiable, ForEach no longer needs id: \.id specified explicitly - it knows to use the id property automatically:

/*
 ForEach(expenses.items) { item in
     Text(item.name)
 }
 */

// Key takeaway: dont use fields like name as identifiers unless true uniqueness is guaranteed. prefer UUID + Identifiable for reliably unique, animatable list items



// ** SHARING AN OBSERVED OBJECT WITH A NEW VIEW **

/*
 //
 //  ContentView.swift
 //  Day37
 //
 //  Created by Ivan Lara on 7/5/26.
 //

 import SwiftUI

 struct ExpenseItem: Identifiable {
     let id = UUID()
     let name: String
     let type: String
     let amount: Double
 }

 @Observable
 class Expenses {
     var items = [ExpenseItem]()
 }

 struct ContentView: View {
     @State private var expenses = Expenses()
     
     @State private var showingAddExpense = false
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(expenses.items) { item in
                     Text(item.name)
                 }
                 .onDelete(perform: removeItems)
             }
             .navigationTitle("iExpense")
             .toolbar {
                 Button("Add Expense", systemImage: "plus") {
                     showingAddExpense = true
                 }
             }
             .sheet(isPresented: $showingAddExpense) {
                 AddView(expenses: expenses)
             }
             
         }
     }
     
     func removeItems(at offsets: IndexSet) {
         expenses.items.remove(atOffsets: offsets)
     }
 }

 #Preview {
     ContentView()
 }
 */

// - and then we have an add view

/*
 //
 //  AddView.swift
 //  Day37
 //
 //  Created by Ivan Lara on 7/5/26.
 //

 import SwiftUI

 struct AddView: View {
     @State private var name = ""
     @State private var type = "Personal"
     @State private var amount = 0.0

     var expenses: Expenses
     
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
                 
                 TextField("Amount", value: $amount, format: .currency(code: "USD"))
                     .keyboardType(.decimalPad)
             }
             .navigationTitle("Add new expense")
         }
     }
 }

 #Preview {
     AddView(expenses: Expenses())
 }

 */

// - goal: create a separate AddView for adding new expenses, and have it share the same Expenses object as ContentView (not a separate instance), so canges automatically reflect back in the original list - thanks to @observable.

// Key concept: @Observable classes can be used across multiple biews. SwiftUI only refreshes views that actually use the properties that changed.

// 1. create AddView.swift (CMD + N), with a form entering expense details:
/*
 struct AddView: View {
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

                 TextField("Amount", value: $amount, format: .currency(code: "USD"))
                     .keyboardType(.decimalPad)
             }
             .navigationTitle("Add new expense")
         }
     }
 }
 
 */

// - note: currency is hardcoded to USD - meant to be improved later as a challenge

// 2. in ContentView, add state to control showing the sheet:

// @State private var showingAddExpense = false

// 3. attach .sheet() modifier to present AddView:

// .sheet(isPresented: $showingAddExpense) {
//AddView(expenses: expenses)
//}

// 4. Share the Expenses instance - dont create a new one in AddView, add a property to AddView:

// var expenses: Expenses

// this lets both views reference and observe the same object

// 5. fix the #preview (since AddView no requires an expenses param):

// #Preview {
//    AddView(expenses: Expenses())
//}

// 6. Wire up the + button to actually show the sheet (replacing old test-expense logic):

// Button("Add Expense", systemImage: "plus") {
//showingAddExpense = true
//}

// - Result: Tapping + presents AddView as a sheet; entering data there (once wired up) will update the shared Expenses object, and ContentView's list will automatically refresh



// ** MAKING CHANGES PERMANENT WITH USERDEFAULTS **

/*
 import SwiftUI

 struct ExpenseItem: Identifiable, Codable {
     var id = UUID()
     let name: String
     let type: String
     let amount: Double
 }

 @Observable
 class Expenses {
     var items = [ExpenseItem]() {
         didSet {
             if let encoded = try? JSONEncoder().encode(items) {
                 UserDefaults.standard.set(encoded, forKey: "Items")
             }
         }
     }
     
     init() {
         if let savedItems = UserDefaults.standard.data(forKey: "Items") {
             if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                 items = decodedItems
                 return
             }
         }
         
         items = []
     }
 }

 struct ContentView: View {
     @State private var expenses = Expenses()
     
     @State private var showingAddExpense = false
     
     var body: some View {
         NavigationStack {
             List {
                 ForEach(expenses.items) { item in
                     Text(item.name)
                 }
                 .onDelete(perform: removeItems)
             }
             .navigationTitle("iExpense")
             .toolbar {
                 Button("Add Expense", systemImage: "plus") {
                     showingAddExpense = true
                 }
             }
             .sheet(isPresented: $showingAddExpense) {
                 AddView(expenses: expenses)
             }
             
         }
     }
     
     func removeItems(at offsets: IndexSet) {
         expenses.items.remove(atOffsets: offsets)
     }
 }

 #Preview {
     ContentView()
 }
 */

/*

 Problem 1: The "Save" button doesn't actually save anything yet
 
 Right now AddView has text fields and a picker, but nothing happens when you tap Save. We fix that by turning the form's values into an ExpenseItem and adding it to the shared expenses object:
 
 .toolbar {
     Button("Save") {
         let item = ExpenseItem(name: name, type: type, amount: amount)
         expenses.items.append(item)
     }
 }
 
 At this point: add → save → dismiss → item appears in the lis
 t. But if you quit and relaunch the app, everything is gone. That's Problem 2.
 
 Problem 2: Data disappears when the app closes
 This is because everything currently only lives in memory (RAM) while the app is running. To fix it, we need to write data to disk when it changes, and read it back when the app starts. This uses 4 pieces:

 1. Codable — lets us convert ExpenseItem structs into a saveable format (JSON)
 2. UserDefaults — where we physically store/retrieve that saved data
 3. A custom initializer on Expenses — loads saved data back in when the app launches
 4. didSet on items** — automatically saves every time the array changes (add or delete)

 Think of it like this: didSet is the "save on every change" trigger, and the custom init() is the "load once when starting up" trigger.
 
 Step A: Make ExpenseItem "convertible" to save-able data
 
 struct ExpenseItem: Identifiable, Codable {
     var id = UUID()   // note: changed from `let` to `var`
     let name: String
     let type: String
     let amount: Double
 }

    + Adding Codable lets Swift auto-generate the encode/decode logic (works because UUID, String, Double are all already Codable).
    + id was changed from let to var just to silence a compiler warning about decoding — doesn't change behavior meaningfully here.

 Step B: Auto-save whenever items changes
 
 var items = [ExpenseItem]() {
     didSet {
         if let encoded = try? JSONEncoder().encode(items) {
             UserDefaults.standard.set(encoded, forKey: "Items")
         }
     }
 }
 
 In plain English: "Every time items is modified (append, remove, etc.), convert the whole array into JSON Data, then save that under the key "Items" in UserDefaults."

    + didSet = a property observer, code that runs automatically right after a property's value changes.
    + JSONEncoder().encode(items) = "create an encoder, and immediately use it to turn items into JSON data" in one line.

 Step C: Load saved data back when the app starts
 
 swiftinit() {
     if let savedItems = UserDefaults.standard.data(forKey: "Items") {
         if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
             items = decodedItems
             return
         }
     }
     items = []
 }
 
 In plain English, step by step:

    1. Try to pull raw Data out of UserDefaults under the key "Items".
    2. If that succeeded, try to decode it back into [ExpenseItem] using JSONDecoder.
    3. If decoding worked, assign it to items and stop (return).
    4. If either step failed (e.g., first launch, nothing saved yet), just start with an empty array.

 About [ExpenseItem].self: the .self just tells Swift "I mean the type itself here, not an instance of it." Without .self, Swift can't tell if you mean the type, a static member, or something else — it's just required syntax when referring to a type as a value.
 
 Putting it together — the full lifecycle:

 1. App launches → Expenses() is created → init() runs → loads saved items from UserDefaults (or starts empty).
 2. User adds/deletes an expense → items array changes → didSet fires → new data is immediately re-saved to UserDefaults.
 3. Repeat forever — every change is saved instantly, and every launch loads the latest saved state.

 Bottom line: This is the classic "save on every change, load once at startup" pattern for persisting data with UserDefaults. Codable is the translator between Swift structs and storable JSON data; UserDefaults is where the JSON actually lives.
 */


// ** FINAL POLISH **

// problem 1: Saving an expense doesnt dismiss AddView
// to dismiss the sheet from within AddView, use the dismiss environment value.

// 1. Add this property to AddView:

// @environment(\.dismiss) var dismiss

// - no type is specified - the @environment property wrapper figures that out automatically

// 2. call it right after saving the expense (in the save buttons action):

// dismiss()

// - this flips the showingAddExpense back to false in ContentView, closing the sheet automatically.

// problem 2: The list only shows the expense name - no type or amount

// currently:

// ForEach(expenses.items) { item in
//  Text(item.name)
//}

// replace it with a nested stack layout (a common IOS pattern: title/subtitle on the left, extra info on the right):

/*
ForEach(expenses.items) { item in
    HStack {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
            Text(item.type)
        }
 
        Spacer()
        Text(item.amount, format: .currency(code: "USD"))
    }
 }
 */

// Layout breakdown:
//  + inner VStack(left-aligned): expense name (bold/headline) stacked above its type
//  + Spacer(): Pushes everything apart, pinning the amount to the right edge
//  + Outer HStack: arranges the VStack and the amount Text side-by-side

// Result: each row now shows name + type on the left, amount on the right - and adding an expense properly dismisses the sheet. project complete.
