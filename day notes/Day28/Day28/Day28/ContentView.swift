//
//  ContentView.swift
//  Day28
//
//  Created by Ivan Lara on 5/25/26.
//

// CHALLENGE:
//1) Replace each VStack in our form with a Section, where the text view is the title of the section. Do you prefer this layout or the VStack layout?

// Answer: I prefer the VStack option. If there are more UI details to add for each section, section might be better since it gives it a bit more space. But i feel VStack helps keep everything nice and clean.

//2) Replace the “Number of cups” stepper with a Picker showing the same range of values.

// Answer; replaced stepper with the following code:

//  Picker("How many cups of coffee?", selection: $coffeeAmount) {
//      ForEach(1...20, id: \.self) {
//          Text("^[\($0) cup](inflect: true)")}


//3) Change the user interface so that it always shows their recommended bedtime using a nice and large font. You should be able to remove the “Calculate” button entirely.

// Answer: deleted all the @State variables for the alerts. changed function returns to Strings. added a return string to func.

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up? ☀️")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
                            .hourAndMinute)
                    .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep 😴")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:
                                4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake ☕️")
                        .font(.headline)
                    
                    Picker("How many cups of coffee?", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                }
                
                Section("Recommended Bedtime"){
                    Text("You should go to bed at \(calculateBedTime())❗️")
                        .font(.headline)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
}
    #Preview {
        ContentView()
    }

