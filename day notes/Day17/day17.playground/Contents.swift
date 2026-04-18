import Cocoa

/// **DAY 17**

// - project 1, part 2


///**READING TEXT FROM THE USER WITH TEXTFIELD**
/*
 import SwiftUI
 
 struct ContentView: View {
 @State private var checkAmount = 0.0
 @State private var numberOfPeople = 2
 @State private var tipPercentage = 20
 
 let tipPercentages = [10, 15, 20, 25,0]
 
 var body: some View {
 Form {
 Section {
 TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
 .keyboardType(.decimalPad)
 }
 
 Section {
 Text(checkAmount, format: .currency(code:
 Locale.current.currency?.identifier ?? "USD"))
 }
 }
 }
 }
 
 #Preview {
 ContentView()
 }
 
 import SwiftUI          → load the framework
 struct : View           → define a screen
 @State var              → variables that update the UI
 let                     → fixed data
 body                    → what's drawn on screen
 Form > Section          → layout containers
 TextField($binding)     → user input
 Text(value)             → display output
 #Preview                → canvas preview only
 
 
 **CREATING PICKERS IN A FORM**
 
 - pickers need a two-way binding $propertyName to track their selected value, just like text fields
 - If your ForEach starts at 2, row 0 = "2 people", row 2 = "4 people". so a default value of 2 actually selects the third item - not a bug, just how indexing works
 - 3 pickers styles to know:
 + Deafult(menu) - shows current value with arrows, taps open a dropdown
 + .pickerStyle(.navigationLink) - slides user to a new screen with all options. requires NavigationStack wrapper to work
 + Segmented - best for small sets of options(used later for tip %)
 
 
 import SwiftUI
 
 struct ContentView: View {
 @State private var checkAmount = 0.0
 @State private var numberOfPeople = 2
 @State private var tipPercentage = 20
 
 let tipPercentages = [10, 15, 20, 25,0]
 
 var body: some View {
 NavigationStack {
 Form {
 Section {
 TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
 .keyboardType(.decimalPad)
 
 Picker("Number of people", selection: $numberOfPeople) {
 ForEach(2..<100) {
 Text("\($0) people")
 }
 }
 }
 Section {
 Text(checkAmount, format: .currency(code:
 Locale.current.currency?.identifier ?? "USD"))
 }
 }
 .navigationTitle("WeSplit")
 }
 }
 }
 
 #Preview {
 ContentView()
 }
 
 
 - Wrap your Form in NavigationStack {} when using navigation link pickers, it provides the space and sliding behavior needed
 - Add a nav title to the form, not the stack:
 - Form {...}
 .navigationTitle("WeSplit")
 - SwiftUI is declarative - you describe what you want (a navigation picker with these values), not how to build it
 
 **ADDING A SEGMENTED CONTROL FOR TIP PERCENTAGES**
 
 - Section("How much tip do you want leave?") {
 Picker("Tip percentage", selection" $tipPercentage) {
 ForEach(tipPercentages, id: \.self) {
 Text($0, format: .percent)
 }
 }
 .pickerStyle(.segmented)
 }
 
 - ForEach(tipPercentages, id: \.self) - loops over tip options array
 - .percent - format - auto-formats numbers as percentages
 - .pickerStyle(.segmented) - converts the default pop-up picker into a horizontal segmented control
 - ux note: dont use a loose Text() view inside the section - it looks disconnected. instead, pass the label string directly to the Section as a header (as shown above). this makes it read as a prompt for the control below it, not a standalone item
 
 **Calculating the total per person**
 
 - adding a computed property that calculates each persons share of the bill
 - The computed property:
 - Add totalPerPerson just before the body property
 
 var totalPerPerson: Double {
 let peopleCount = Double(numberOfpeople + 2) // offset: picker starts at 0
 let tipSelection = Double(tipPercentage)
 
 let tipValue = checkAmount / 100 * tipSelection
 let grandTotal = checkAmount + tipValue
 let amountPerPerson = grandTotal / peopleCount
 
 return amountPerPerson
 }
 
 Key notes:
 - numberOfpeople + 2  - corrects for the pickers 0-based index (range 2-100)
 - Both values cast to Double to work alongside checkAmount
 - Math; tip -> grand total -> divide by people
 
 Update the Output section:
 - Swap checkAmount for totalPerPerson in the final section
 
 Section {
 Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
 }
 
 - all input values use @state, so any change automatically triggers a recalculation and re-renders the view - no manual refresh needed. This is SwiftUIs core principle: views are a function of their state
 
 
 **HIDING THE KEYBOARD**
 Goal : To dismiss the number keypad (which has no return key) via a toolbar "Done" button
 
 1.) Track focus state
 
 @FocusState private var amountIsFocused: Bool
 
 Then attach it to the TextField:
 
 .focused($amountIsFocused)
 
 - @FocusState works like @state but is specifically designed to track input focus - when the field is active, amountIsFocused is true
 
 2.) Add a Toolbar "Done" Button
 
 - add this modifier to the form, below .navigationTitle()
 
 .toolbar {
    if amountIsFocused {
        Button("Done") {
            amountIsFocused = false
        }
    }
}

- .toolbar - palces items in the nav bar or bottom toolbar area
- the if condition - only shows the button when the text field is active
- the Button - sets amountIsFocused = false, which dismisses the keyboard

- this is needed because number/decimal keypads have no built-in return key, unlike the alphabetic keyboard.
- This pattern(FocusState + toolbar button) is the standard SwiftUI fix
