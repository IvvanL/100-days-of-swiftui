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

// ** WORKING WITH DATES **

//import SwiftUI

//struct ContentView: View {
//    var body: some View {
//      Text(Date.now, format: .dateTime.day().month().year())
//        Text(Date.now.formatted(date: .long, time: .shortened))
//    }
//        func exampleDates() {
            //        var components = DateComponents()
            //        components.hour = 8
            //        components.minute = 0
            //        let date = Calendar.current.date(from: components) ?? .now
            
//            let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
//            let hour = components.hour ?? 0
//            let minute = components.minute ?? 0
//        }
//    }

//#Preview {
//    ContentView()
//}

// Key Types:
// Date - full timestamp(year,month,day,hour,minute,timezone,etc)
// DateComponents - lets you read/write specific parts of a date
// Calendar.current - use for all calculations and conversions

// Common Tasks:

// - Default time(ex. 8am today):

//var components = DateComponents()
//components.hour = 8
//let date = Calendar.current.date(from: components) ?? .now

// - extract hour/minute from a date:

// let components = Calendar.current.dateComponents([.hour, .minute], from: someDate)
// let hour = components.hour ?? 0
// let minute = components.minute ?? 0

// - Formatting for display:

//Text(Date.now, format: .dateTime.hour().minute())       // time only
//Text(Date.now, format: .dateTime.day().month().year())  // date only
//Text(Date.now.formatted(date: .long, time: .shortened)) // both

// iOS automatically handles regional format differences (e.g. DD/MM/YY vs MM/DD/YY)

// ** TRAINING A MODEL WITH CREATE ML **

// - Create ML (for training) and Core ML (for in-app inference) make on-device machine learning accessible.
// - the example will cover Tabular regression - finding relationships in spreadsheet-like data

// Two-Step ML process
//  + training - computer analyzes data to learn relationships (can take hours for large datasets)
//  + Prediction - done on-device using the trained model

// Steps to train a model
// 1. Open Create ML → New Document → choose Tabular Regression
// 2. Import your CSV as training data
// 3. Set your target (what to predict) and features (inputs used to predict it)
// 4. Choose an algorithm — Automatic works well for most cases
// 5. Click Train, then review results in the Evaluation → Validation tab
// 6. Export the finished model via the Output tab

// Key metrics
// - Root Mean Squared error (RMSE) - lower is better; the example achieved ~170 seconds of error
// - create ML auto-splits data into training and validation sets

// Model size
// - Trained models are tiny (ex. 545 bytes from 180KB of data) because only the mathematical relationships are stored, not the raw data.

// Watched youtube video on Create ML coveing:
// 1. image recognition
// 2. Sentiment analysis
// 3. Regression analysis
// link: https://www.youtube.com/watch?v=a905KIBw1hs
