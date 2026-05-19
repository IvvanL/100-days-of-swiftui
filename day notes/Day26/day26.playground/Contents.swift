import Cocoa

// ** DAY 26 PROJECT 4 - BetterRest - PART 1 **

// INTRODUCTION
// The app is called better rest, and its designed to help coffee drinkers get a good nights sleep by asking them 3 questions:
// 1. when do they want to wake up
// 2. Roughly how many hours of sleep do they want
// 3. how many cups of coffee do they drink per day

// ** ENTERING NUMBERS WITH STEPPER **

// import SwiftUI

// struct ContentView: View {
//    @State private var sleepAmount = 8.0
//
//    var body: some View {
//        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
//    }
//}
//
//#Preview {
//    ContentView()
//}

// Stepper provides - and + buttond for precise number input. it works with any numeric type(Int, Double, etc)
// parameters:
// + in: - sets a range(ex. in: 4...12) to cap min/max values
// + step: - controls increment size (ex. step: 0.25 for 15 min jumps); must match the bindings type

// formatting tip: use .formatted() to clean up Double display - 8.00000 becomes 8.

// ** SELECTING DATES AND TIMES WITH DATEPICKER **

// import SwiftUI

//struct ContentView: View {
//    @State private var wakeUp = Date.now
    
//    var body: some View {
//        DatePicker("Please enter a date", selection: $wakeUp,in: Date.now...) //future dates only
//                .labelsHidden()
//    }
    
//    func exampleDates() {
//        let tomorrow = Date.now.addingTimeInterval(86400) //tomorrow only
//        let range = Date.now...tomorrow
//    }
//}

//#Preview {
//    ContentView()
//}

// DatePicker binds to swifts Date type using @State:

// @State private var wakeUp = Date.now
// DatePicker("Please enter a date", selection" $wakeUp)

// Hiding the label
// + use .labelsHidden() - keeps the label for VoiceOver but hides it visually. dont use an empty string "" as it wastes space and breaks visibility

// displayedComponents options:
// - Default - day, hour, minute
// - .date - month, day, year
// - .hourAndMinute - time only

// restricting dates with in: works like Stepper, and supports one-sided ranges

