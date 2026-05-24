// ** DAY 27 - PROJECT 4 - BETTERREST - PART 2 **

// ** BUILDING A BASIC LAYOUT **

/* import SwiftUI
 
 struct ContentView: View {
 
 @State private var wakeUp = Date.now
 @State private var sleepAmount = 8.0
 @State private var coffeeAmount = 1
 
 var body: some View {
 NavigationStack {
 VStack {
 Text("When do you want to wake up?")
 .font(.headline)
 
 DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
 .hourAndMinute)
 .labelsHidden()
 
 Text("Desired amount of sleep")
 .font(.headline)
 
 Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:
 4...12, step: 0.25)
 
 Text("Daily coffee intake")
 .font(.headline)
 
 Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
 }
 .navigationTitle("BetterRest")
 .toolbar {
 Button("Calculate", action: calculateBedTime)
 }
 }
 }
 
 func calculateBedTime() {
 }
 }
 #Preview {
 ContentView()
 }
 
 // **  Building a Basic Layout – BetterRest App **
 // State Properties - Three @State variables to store user input:
 
 // 1. wakeUp — a Date (defaults to now)
 // 2. sleepAmount — a Double (defaults to 8.0)
 // 3. coffeeAmount — an Int (defaults to 1)
 
 // UI Structure - Wrapped in a NavigationStack → VStack containing three input sections:
 
 // 1. Wake-up time — DatePicker with .hourAndMinute and .labelsHidden()
 // 2. Sleep amount — Stepper with range 4...12, step 0.25, displayed using .formatted()
 // 3. Coffee intake — Stepper with range 1...20
 
 // Navigation Bar
 
 // - navigationTitle("BetterRest") for the title
 // - A Calculate button added via .toolbar {} that calls calculateBedtime() (empty for now — logic comes later)
 // - Button auto-positions right for LTR languages, left for RTL
 
 // ** CONNECTING SWIFTUI TO CORE ML **
 
 import CoreML
 import SwiftUI
 
 struct ContentView: View {
 
 @State private var wakeUp = Date.now
 @State private var sleepAmount = 8.0
 @State private var coffeeAmount = 1
 
 @State private var alertTitle = ""
 @State private var alertMessage = ""
 @State private var showingAlert = false
 
 var body: some View {
 NavigationStack {
 VStack {
 Text("When do you want to wake up?")
 .font(.headline)
 
 DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
 .hourAndMinute)
 .labelsHidden()
 
 Text("Desired amount of sleep")
 .font(.headline)
 
 Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:
 4...12, step: 0.25)
 
 Text("Daily coffee intake")
 .font(.headline)
 
 Stepper("\(coffeeAmount) cup(s)", value: $coffeeAmount, in: 1...20)
 }
 .navigationTitle("BetterRest")
 .toolbar {
 Button("Calculate", action: calculateBedTime)
 }
 .alert(alertTitle, isPresented: $showingAlert) {
 Button("OK") {}
 } message: {
 Text(alertMessage)
 }
 }
 }
 
 func calculateBedTime() {
 do {
 let config = MLModelConfiguration()
 let model = try SleepCalculator(configuration: config)
 
 let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
 let hour = (components.hour ?? 0) * 60 * 60
 let minute = (components.minute ?? 0) * 60
 
 let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
 
 let sleepTime = wakeUp - prediction.actualSleep
 
 alertTitle = "Your ideal bedtime is..."
 alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
 } catch {
 alertTitle = "Error"
 alertMessage = "Sorry, there was a problem calculating your bedtime."
 }
 
 showingAlert = true
 }
 }
 #Preview {
 ContentView()
 }
 
 // Key Takeaways
 // - .mlmodel files automatically generate Swift classes.
 // - Use MLModelConfiguration() and try to load Core ML models.
 // - Convert Date values into the format expected by the model.
 // - Use prediction() to get machine learning results.
 // - Convert the prediction into user-friendly output and display it with a SwiftUI alert.
 // - Wrap Core ML code in do/catch for error handling.
 
 // STATE -> UI -> BUTTON -> CALCULATION
 
 // ** CLEANING UP THE USER INTERFACE **
 
 import CoreML
 import SwiftUI
 
 struct ContentView: View {
 
 @State private var wakeUp = defaultWakeTime
 @State private var sleepAmount = 8.0
 @State private var coffeeAmount = 1
 
 @State private var alertTitle = ""
 @State private var alertMessage = ""
 @State private var showingAlert = false
 
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
 Text("When do you want to wake up?")
 .font(.headline)
 
 DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
 .hourAndMinute)
 .labelsHidden()
 }
 
 VStack(alignment: .leading, spacing: 0) {
 Text("Desired amount of sleep")
 .font(.headline)
 
 Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:
 4...12, step: 0.25)
 }
 
 VStack(alignment: .leading, spacing: 0) {
 Text("Daily coffee intake")
 .font(.headline)
 
 Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
 }
 }
 .navigationTitle("BetterRest")
 .toolbar {
 Button("Calculate", action: calculateBedTime)
 }
 .alert(alertTitle, isPresented: $showingAlert) {
 Button("OK") {}
 } message: {
 Text(alertMessage)
 }
 }
 }
 
 func calculateBedTime() {
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
 
 alertTitle = "Your ideal bedtime is..."
 alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
 } catch {
 alertTitle = "Error"
 alertMessage = "Sorry, there was a problem calculating your bedtime."
 }
 
 showingAlert = true
 }
 }
 #Preview {
 ContentView()
 }
 
 // Cleaning up the BetterRest UI
 
 // 1. SET A BETTER DEFAULT WAKE-UP TIME
 //     + date.now uses the current time, which isnt ideal
 //     + create a static  computed property that returns 7:00am as the default wake-up time.
 
 static var defaultWakeTime: Date {
 var components = DateComponents()
 components.hour = 7
 components.minute = 0
 return Calendar.current.date(from: components) ?? .now
 }
 
 //  Use it:
 
 @State private var wakeUp = defaultWakeTime
 
 // Why static?
 // - property initializers cant depend on other instance properties
 // - static belongs to the type itself, so its available immediately
 
 // 2. REPLACE VSTACK with FORM
 
 // before:
 NavigationStack {
 VStack {
 
 // after:
 NavigationStack {
 Form {
 
 // benefits:
 // + more native IOS appearance
 // + better spacing and organization
 // + automatically styled like a settings screen
 
 3. GROUP RELATED CONTROLS WITH VSTACK
 
 VStack(alignment: .leading, spacing: 0) {
 Text("Desired amount of sleep")
 .font(.headline)
 
 Stepper(...)
 }
 
 // - why?
 // - makes each label/conctrol pair appear as a single row in the form
 // - improves layout and readability
 
 // 4. AUTOMATIC PLURALIZATION
 
 // - instead of
 "\(coffeeAmount) cup(s)"
 
 // use swiftUI inflection:
 "^[\(coffeeAmount) cup](inflect: true)"
 // - this will make it so that it will say 1 cup, 2 cupS etc.. automatically
 
 // + use a static computed property for sensible default values
 // + use form for input-heavy screens insteadf of VStack
 // Group related UI elements with VStack
 // Use markdown inflection (inflect: true) for automatic pluralization


final code:

 import CoreML
 import SwiftUI

 struct ContentView: View {
     
     @State private var wakeUp = defaultWakeTime
     @State private var sleepAmount = 8.0
     @State private var coffeeAmount = 1
     
     @State private var alertTitle = ""
     @State private var alertMessage = ""
     @State private var showingAlert = false
     
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
                     Text("When do you want to wake up?")
                         .font(.headline)
                     
                     DatePicker("Please enter a time", selection: $wakeUp, displayedComponents:
                             .hourAndMinute)
                     .labelsHidden()
                 }
                 
                 VStack(alignment: .leading, spacing: 0) {
                     Text("Desired amount of sleep")
                         .font(.headline)
                     
                     Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in:
                                 4...12, step: 0.25)
                 }
                 
                 VStack(alignment: .leading, spacing: 0) {
                     Text("Daily coffee intake")
                         .font(.headline)
                     
                     Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                 }
             }
             .navigationTitle("BetterRest")
             .toolbar {
                 Button("Calculate", action: calculateBedTime)
             }
             .alert(alertTitle, isPresented: $showingAlert) {
                 Button("OK") {}
             } message: {
                 Text(alertMessage)
             }
         }
     }
     
     func calculateBedTime() {
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
             
             alertTitle = "Your ideal bedtime is..."
             alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
         } catch {
             alertTitle = "Error"
             alertMessage = "Sorry, there was a problem calculating your bedtime."
         }
         
         showingAlert = true
     }
 }
     #Preview {
         ContentView()
     }
