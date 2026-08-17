// ** Day 45 Project 9 part 3

// ** CUSTOMIZING THE NAVIGATION BAR APPEARANCE **

/*
 ## Customizing Navigation Bar Appearance

 **Title display mode**
 Use `.navigationBarTitleDisplayMode(.inline)` for a small title (vs. the default large title).

 **Background color**
 Nav bar is invisible until you scroll — then it shows a gray background by default. Change it with:

 .toolbarBackground(.blue)

 **Fixing text contrast**
 Colored backgrounds can make title text hard to read (black text in light mode). Force dark mode on the bar to get white text:

 .toolbarColorScheme(.dark)
 
 **Targeting just the nav bar**
 
 Both modifiers above affect all toolbars by default. Add `for: .navigationBar` as a second parameter to scope them to just the navigation bar.

 **Hiding the nav bar**

 .toolbar(.hidden, for: .navigationBar)

 Navigation still works with the bar hidden, but scrolling content may go under system UI (like the clock) — use with caution.
*/

// ** PLACING TOOLBAR BUTTONS IN EXACT LOCATIONS **

/*
 **Default behavior**
 
 SwiftUI auto-places toolbar buttons based on platform — on iOS with left-to-right languages, they default to the right side of the nav bar.

 **Manual placement with `ToolbarItem`**
 
 Wrap buttons in `ToolbarItem(placement:)` to control positioning explicitly:

 .toolbar {
     ToolbarItem(placement: .topBarLeading) {
         Button("Tap Me") { }
     }
 }

 **Semantic placements (preferred)**
 
 Instead of raw positions, use placements that convey *meaning*:
 - `.confirmationAction` — agreeing to something (e.g., terms of service)
 - `.destructiveAction` — destructive choices (e.g., deleting data)
 - `.cancellationAction` — backing out of changes
 - `.navigation` — moving between data (e.g., back/forward)

 Benefits: iOS can apply extra styling automatically (e.g., bold for confirmation buttons), and placement adapts correctly across platforms (iOS, macOS, watchOS, etc.).

 **Tip:** When forcing a save/discard decision, pair with `.navigationBarBackButtonHidden()` so users can't tap Back to dodge the choice.

 **Multiple buttons, same placement**
 Either repeat `ToolbarItem`:

 .toolbar {
     ToolbarItem(placement: .topBarLeading) { Button("Tap Me") { } }
     ToolbarItem(placement: .topBarLeading) { Button("Or Tap Me") { } }
 }
 
 Or group them with `ToolbarItemGroup`:
 
 .toolbar {
     ToolbarItemGroup(placement: .topBarLeading) {
         Button("Tap Me") { }
         Button("Tap Me 2") { }
     }
 }
 
 Both produce the same result.
 
*/

// ** MAKING YOUR NAVIGATION TITLE EDITABLE **

/*
 ## Making Your Navigation Title Editable

 **Basic title (static string)**
 
 .navigationTitle("SwiftUI")

 **Editable title (binding)**
 When using `.inline` display mode, pass a `Binding<String>` instead of a plain string. iOS then shows a small arrow next to the title with a "Rename" option to edit it:
 
 struct ContentView: View {
     @State private var title = "SwiftUI"

     var body: some View {
         NavigationStack {
             Text("Hello, world!")
                 .navigationTitle($title)
                 .navigationBarTitleDisplayMode(.inline)
         }
     }
 }

 **Use case**
 Handy when the title represents something the user named — lets them rename it directly via the nav bar instead of adding a separate text field to the UI.
 */
