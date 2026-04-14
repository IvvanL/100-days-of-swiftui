import Cocoa

///**DAY 16 WeSplit Project  part 1 - NOTES**

///**CREATING A FORM**
// - forms are scrolling lists of static controls like text and images, but can also include user interactive controls like text fields, toggle switches, buttons, and more
// - learned how to divide a form with sections
// example:
/*
struct ContentView: View { //basic protocol
    var body: some View {
        Form {
            Section {
                Text("Hello World")
            }
            
            Section {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
            
            Section {
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
                Text("Hello World")
            }
        }
    }
}

#Preview {
    ContentView()
}
*/

///**ADDING A NAVIGATION BAR**
/*
struct ContentView: View { //basic protocol
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Hello World")
                }
                
                Section {
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                }
                
                Section {
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                }
            }
            .navigationTitle("SwiftUI") // inside nagivation stack
            .navigationBarTitleDisplayMode(.inline) // inside navigation stack
        }
    }
}

#Preview {
    ContentView()
}
*/

///**MODIFYING PROGRAM STATE**
/*
import SwiftUI

struct ContentView: View { //basic protocol
    @State private var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
        }
    }
}

#Preview {
    ContentView()
}
 
// - SwiftUI views are structs, and structs are immutable - you cant directly change their properties at runtime
// - a button that tries to increment a counter wont compile because modifying a struct property from within itself isntg allowed in swift
// - the solution: @state: a property wrapper that lets SwiftUI store the value outside the struct in a place it can modify freely
// - best practice, always mark @state properties as private, since theyre meant to belong to a single view only
 
*/

///**Binding state to user interface controls**
/*
import SwiftUI

struct ContentView: View { //basic protocol
    @State private var name = ""
    
    var body: some View {
        Form {
            TextField("Enter your Name", text: $name)
            Text("Your name is \(name)")
        }
    }
}

#Preview {
    ContentView()
}

// - Two-way binding - when SwiftUI needs to both read and write a property when tied to an input control
// - UI controls like TextField dont just display data, they also need to write back changes. a regular property or even @State alone is not enough
example:
TextField("Enter your Name", text: $name) // two-way: reads AND writes
Text("Your name is \(name)")              // one-way: reads only

full pattern for a working text field:
                        
@State private var name = ""
                    
TextField("Enter your name", text: $name)

// simple rule to remember - use $propertyName when control needs to read and write(TextField, Toggle, slider etc.
// - use propertyName (no $) when you just need to display a value

// does the user interact with it to change a value? -> two-way binding
// Does it just display something? -> read only (no $)

///**CREATING VIEWS IN A LOOP**
import SwiftUI

struct ContentView: View { //basic protocol
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = "Harry"
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Select a student")
        }
    }
}

#Preview {
    ContentView()
}
   
// - ForEach - a dedicated SwiftUI view for creating multiple views from an array or range in a loop
// - id: \.self  - SwiftUI needs to uniquely identify every view on screen so it can track changes. this tells SwiftUI "The string itself is the unique identifier

// - ForEach(students, id: \.self) {
        Text($0)
    }

Works fine as long as your array has no duplicates
With structs, you'd use a unique property instead (like \.id or \.title)

// - When you don't need id: — ranges like 0..<100 already have unique numbers, so no id needed
   
// - Constants vs. State:
   
   - A fixed array (let students = [...]) doesn't need @State — it never changes
   - The selected value from a Picker does need @State — the user changes it
   
*/*/


