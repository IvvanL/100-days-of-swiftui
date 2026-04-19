//
//  ContentView.swift
//  Day19 - Challenge - Unitopia
//
//  Created by Ivan Lara on 4/18/26.
//

import SwiftUI

struct ContentView: View {
    @State private var inputNumber = 0.0 // user inputs seconds
    @State private var inputUnit = ["Seconds", "Minutes", "Hours", "Days"]//user inputs desired unit
    @State private var outputNumber = 0.0 // putputs the input to desired unit
    @State private var isDarkMode = false // dark mode is always the best duh
    @State private var selectedUnit = "Seconds"
    @FocusState private var amountIsFocused: Bool

    var result: Double {
        let conversions: [String: Double] = [
            "Seconds": inputNumber,
            "Minutes": inputNumber / 60.0,
            "Hours": inputNumber / 3600.0,
            "Days": inputNumber / 86400.0
        ]
        
        return conversions[selectedUnit] ?? 0.0
        
    }
    var body: some View {
        NavigationStack {
            Form {
                Section ("How many seconds would you like to convert?"){
                    TextField("Amount", value: $inputNumber, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section("Convert to:") {
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(inputUnit, id: \.self) {
                            Text($0)
                        }
                        pickerStyle(.segmented)
                    }
                }
                
                Section("Result") {
                    Text("\(inputNumber.formatted()) seconds = \(result.formatted()) \(selectedUnit)")
                }
         
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
            }
            .navigationTitle("Unitopia")
            .toolbar {
                if amountIsFocused {
                    Button("DONE") {
                        amountIsFocused = false
                    }
                }
            }
        }
    
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
    
#Preview {
    ContentView()
}
