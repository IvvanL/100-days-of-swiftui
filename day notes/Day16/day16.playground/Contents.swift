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
