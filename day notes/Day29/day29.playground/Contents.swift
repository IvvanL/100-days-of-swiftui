// ** DAY 29 - PROJECT 5 - WORD SCRAMBLE - PART 1 **

// WORD SCRAMBLE:
// - will show players a random 8 letter word and ask them to make words out of it
// - intro to
//  + List
//  + onAppear()
//  + Bundle
//  + fatalError()

// ** INTRODUCING LIST, YOUR BEST FRIEND **

//import SwiftUI

//struct ContentView: View {
//    let people = ["Finn", "Leia", "Luke", "Rey"]
    
//    var body: some View {
//        List {
//            Text("Static Row")
            
//            ForEach(people, id: \.self) {
//                Text($0)
//            }
            
//            Text("Static Row")
//        }
//    }
//}

//#Preview {
//    ContentView()
//}

// List is a scrolling table view (the swiftUI equivalent of UIKits UITableView)
// - its similar to form but for displaying data rather than collecting input

// Content types:
//  + static rows - hardcoded views inside the list
//  + Dynamic rows - generated via ForEach or by passing a range/array directly to List
//  + Mixed - static and dynamic rows can coexist
//  + Sections - use Section("Header") to group rows; String headers are a handy shortcut

// Styling: use .listStyle(.grouped) (or other styles) to change appearance

// Working with arrays:
//  + SwiftUI needs to uniquely identify each row. Use id: \.self when your array contains strings or numbers, since the values themselves serve as identifiers

// List(people, id: \.self) { Text($0) }

// Key difference from Form:
//  + List can generate all rows from dynamic data without a ForEach wrapper - Form cannot
