import Cocoa

/// **DAY 17**
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

*/
