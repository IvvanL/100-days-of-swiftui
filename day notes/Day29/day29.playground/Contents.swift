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


// ** LOADING RESOURCES FROM YOUR APP BUNDLE **

// import SwiftUI

// struct ContentView: View {
//     var body: some View {
//         VStack {
//             Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("hello, world!")
//        }
//        .padding()
//    }
//        func testBundles() {
//            if let fileURL = Bundle.main.url(forResource: "somefile", withExtension: "txt"){
//                if let fileContents = try? String(ContentsOf: fileURL) {
//
//                }
//            }
//        }
//    }

//#Preview {
//    ContentView()
//}

// ** whats an app bundle:
// - when xcode builds your app, it packages everything together - compiled Swift code, artwork, and extra files into a single bundle
// ** why url matters here:
//- Swifts URL type isnt just for web addresses - it also represents file locations, making it the right tool for finding files inside your bundle

// 1. Get the file's URL using Bundle.main.url() — returns an optional, so unwrap it:
// if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
// file found
//}

// 2. Read its contents into a String using String(contentsOf:) — can throw, so use try?:
// if let fileContents = try? String(contentsOf: fileURL) {
// file loaded as a String
// }

// Key notes:
// + Image views handle asset catalog lookups automatically; other file types (text, JSON, XML) require this manual approach
// + dont try to guess or hardcode file paths - your app runs in a sandbox with system - managed paths
// + once loaded, the result is just a plain String to use however you like


// ** WORKING WITH STRING **

// import SwiftUI

// struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello World!")
//        }
//        .padding()
//    }
    
//    func testStrings() {
//        let word = "swift"
//       let checker = UITextChecker()
//
//       let range = NSRange(location: 0, length: word.utf16.count)
//        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0,wrap:
//          false,language: "en")
        
//        let allGood = mispelledRange.location == NSNotFound
//    }
//}

//#Preview {
//    ContentView()
//}

// Splitting strings into arrays:
// - Use components(separatedBy:) to split a string into an array. For line-separated content, split on "\n". Use randomElement() to grab a random item (returns an optional)
// Trimming whitespace:
// - Use trimmingCharacters(in: .whitespacesAndNewlines) to strip spaces, tabs, and lines breaks from the start/end of a string.

// Spell Checking with UITextChecker four steps:
// 1. create your word and a UITextChecker instance
// 2. Define the range using NSRange(location: 0, length: word.utf16.count) - utf16 needed for Objective-C compatibility
// 3. call checker.rangeofMisspelledWord(in: range:startingAt wrap: languauge:)
// 4. check if the results .location == NSNotFound - if true, no mispelling was found

// Key notes:
// - randomElement() returns an optional, so unwrap or use nil coalescing
// - UITextChecker - comes from UIKit (available in SwiftUI automatically) and is Objective-C- based, hence the slightly awkward API
