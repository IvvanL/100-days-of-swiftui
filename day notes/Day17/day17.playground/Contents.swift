import Cocoa

/// **DAY 17**

// - project 1, part 2


///**Reading text from the user with TextField**
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


**Creating pickers in a form**

- pickers need a two-way binding $propertyName to track their selected value, just like text fields
- If your ForEach starts at 2, row 0 = "2 people", row 2 = "4 people". so a default value of 2 actually selects the third item - not a bug, just how indexing works
 - 3 pickers styles to know:
    + Deafult(menu) - shows current value with arrows, taps open a dropdown
    + .pickerStyle(.navigationLink) - slides user to a new screen with all options. requires NavigationStack wrapper to work
    + Segmented - best for small sets of options(used later for tip %)
 
- Wrap your Form in NavigationStack {} when using navigation link pickers, it provides the space and sliding behavior needed
- Add a nav title to the form, not the stack:
 - Form {...}
 .navigationTitle("WeSplit")
- SwiftUI is declarative - you describe what you want (a navigation picker with these values), not how to build it


