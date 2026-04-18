//
//  ContentView.swift
//  Day18 - Challenge
//
//  Created by Ivan Lara on 4/18/26.
//


// CHALLENGE:
// 1. On the third section, add a header that says "Amount per person"
// 2. Add another section showing the total amount for the check – i.e., the original amount plus tip value, without dividing by the number of people.
// 3. Change the tip percentage picker to show a new screen rather than using a segmented control, and give it a wider range of options – everything from 0% to 100%. Tip: use the range 0..<101 for your range rather than a fixed array.
// 4. own challenge: added "recommended" tip option
// 5. own challenge: added dark mode toggle
// 6. own challenge: added a recommended tip not next to 18%

//-------------------------------------------------------------------------------------------

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @State private var isDarkMode = false // added dark mode state
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = Array(0...100) // updated array to show tip percentages from 0-100

    var totalAmount: Double { // created a new computed variable for totalAmount
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        
        return checkAmount + tipValue
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)// calculate the total per person here
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section("How much do you want to tip?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) { percentage in
                            if percentage == 18 { // added recommended tip note on 18%
                                Text("18% (Recommended)")
                            } else {
                                Text(percentage, format: .percent)
                            }
                        }
                    }
                    .pickerStyle(.navigationLink) // updated percentages for tips to show in a new window
                }
                
                Section("Total Amount") { //passed totalAmount to 3rd section to show amount before the split
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Amount Per Person") {
                    Text(totalPerPerson, format: .currency(code:
                    Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Appearance") { // added dark mode section
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            
            .preferredColorScheme(isDarkMode ? .dark : .light) // adding it to navigation stack so the color scheme affects the entire app UI
        
        }
    }
}

#Preview {
    ContentView()
}
