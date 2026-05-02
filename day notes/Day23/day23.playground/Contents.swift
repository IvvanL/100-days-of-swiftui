import Cocoa

/*
 
 ** DAY 23 PROJECT 3 - ViewsAndModifiers PART 1 **
 
 **VIEWS AND MODIFIERS INTRO**
 
 - project 3 will be our first technique project
 - looking at how they work in detail along with why they work that way
 - in this technique project we're going to take a close look at views and view modifiers
 + why does swiftUI use structs for its views?
 + why does it use some View so much?
 + how do modifiers really work?
 
 ** WHY DOES SWIFTUI USE STRUCTS FOR VIEWS **
 
 - 2 main reasons: performance and state management
 
 Performance:
 + structs are simpler and faster than classes
 + in UIkit, every view inherited from UIview which had 200+ properties and methods passed down whether needed or not
 + SwiftUI structs contain only what you can see - no hidden inherited baggage
 + creating thousands of SwiftUI views is essentially free on modern Iphones
 
 State Management(the bigger reason)
 + classes can change their values freely - swiftUI wouldnt know when to update the UI
 + structs force immutability, pushing you toward a cleaner functional design
 + views become simple things that convert data into UI rather than complex objects that grow out of control
 + @state exists - its the controlled way to allow change when needed
 
 Key Takeaway
 + SwiftUI views are intentionally "dumb and inert. They dont mutate over time - they just take data and render it. This makes them predictable, fast, and easy to reason about
 Rule
 + Always use structs for views, never classes - your code either wont compile or will crash at runtime if you try
 
 
 ** WHAT IS BEHIND THE MAIN SWIFTUI VIEW **
 
 - there is nothing behind SwiftUI view
 
 What actually exists behind it:
 - technically theres a UIHostingController - the bridge between UIKit and SwiftUI
 - but you should never try to modify it - it breaks cross-platform support and may stop working in future IOS versions
 - treat it as if nothing else is there
 
 Solution:
 - instead of trying to color whats behind the view, make your view fill the screen using frame():
 
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 
 maxWidth/maxHeight VS width/height
 + width/height - forces an exact size
 + maxWidth/maxHeight - says "you CAN take up this much space" but still lets other views get their share
 
 ** WHY MODIFIER ORDER MATTERS **
 The core concept:
 + Every modifier creates a brand new view with that change applied — it doesn't modify the existing view in place. Modifiers stack up like layers, each wrapping the previous one
 
 practical example:
 Button("Hello")
 .background(.red)  // colors just the button
 .frame(200x200)    // expands frame, but background already applied
 
 VS
 
 Button("Hello")
 .frame(200x200)    // expands first
 .background(.red)  // now colors the full 200x200 area
 
 - Key Takeaway: Modifier order = rendering order. Always think about what exists at the time each modifier is applied
 
 
 ** WHY DOES SWWIFTUI USE "SOME VIEW" FOR ITS VIEW TYPE **
 
 What it is: an opaque return type - "one object conforming to view, but i dont need to specify which"
 
 - why not just view?
 + the view protocol has an associated type (a "hole" that must be filled with a concrete type)
 + writing var body: view is illegal, you need something specific like var body: Text - or some view to let the compiler figure it out.
 
 - 2 reasons why it exists
 1) performance - swiftUI tracks view changes to update the UI efficiently. without type info, it would have to rebuild everything from scratch on every change
 2) Handles complex types - chaining modifiers creates deeply nested ModifiedContent types. some view lets you avoid writing those out explicitly
 
 - How multiple views are handled
 + a VStack with multiple children silently wraps them in a TupleView (ex. TupleView<(Text, Text)>
 + The body property is implicitly annotated with @viewbuilder, which does the same wrapping automatically when you return multiple views without a stack
 
 ** CONDITIONAL MODIFIERS **
 
 - Use the ternary operatot to apply modifiers conditionally, rather than if/else blocks
 - Syntax reminder (WTF): What do you want to check -> true -> false
 
 import SwiftUI
 
 struct ContentView: View {
 @State private var useRedText = false
 
 var body: some View {
 Button("Hello, world!") {
 useRedText.toggle()
 }
 .foregroundStyle(useRedText ? .red : .blue)
 }
 }
 
 #Preview {
 ContentView()
 }
 
 - why not if/else?
 + when you use an if/else to return different views, SwiftUI treats them as two separate views - destroying one and creating the other on each toggle
 + the ternary operator keeps it as one view with a changing property, which is more efficient.
 
 - rule of thumb: Prefer ternary over if/elswe for conditional modifiers whenever possible
 
 
 ** ENVIRONMENT MODIFIERS **
 
 import SwiftUI
 
 struct ContentView: View {
 
 var body: some View {
 VStack {
 Text("Gryffindor")
 .blur(radius: 0)
 Text("Hufflepuff")
 Text("Ravenclaw")
 Text("Slytherin")
 }
 .blur(radius: 1)
 }
 }
 
 #Preview {
 ContentView()
 }
 
 - are applied to a container( ex. VStack) that automatically propagate to all child views.
 - child views can override an environtment modifier with their own value - the childs version takes priority
 
 VStack {...}
 .font(.title) // applies to all children , but children can overrride
 
 - regular modifiers (like .blur() are additive - a child views version stacks on top of the parents rather than reaplcing it
 - theres not definitive list of which modifiers are "environment" vs "regular" - you have to check the docs case by case
 - use environment modifiers to set defaults across many views at once; expect child overrides to work for environment modifiers but not for regular ones
 
 ** VIEWS AS PROPERTIES **
 
 What it is:
 - storing views as properties on your ContentView struct to keep body cleaner and avoid repetition
 
 Stored property:
 - simple but limited - cant reference other stored properties
 
 let motto1 = Text("Draco dormiens")
 
 computed proprety:
 - more flexible and you can apply modifiers at the call site
 
 var motto1: some View { Text("Draco dormien") }
 
 Returning multiple views from a computed property - 3 options:
 - wrap in a stack (VStack, HStack) - use when layout matters
 - wrap in a group - use when you want the caller to decide layout
 - add @ViewBuilder - mirrors how body works, generally preferred
 
 when to use this pattern: Great for breaking up complex views, but if properties start  getting very large, thats a sign the view itseld should be split into separate structs
 
 ** VIEW COMPOSITION **
 
 import SwiftUI
 
 struct CapsuleText: View {
 var text: String
 
 var body: some View {
 Text(text)
 .font(.largeTitle)
 .padding()
 .background(.blue)
 .clipShape(.capsule)
 }
 }
 
 struct ContentView: View {
 var body: some View  {
 VStack(spacing: 10) {
 CapsuleText(text: "First")
 .foregroundStyle(.white)
 CapsuleText(text: "Second")
 .foregroundStyle(.yellow)
 }
 }
 }
 
 #Preview {
 ContentView()
 }
 
 - swiftUI encourages bnreaking large views into smaller reusable custom views with no meaningful performance cost
 - issue: repeated styling code across multiple views is verbose and hard to mantain
 - The solution: extract repeated view into its own struct. for example, a styled Text with font, padding, colors and a capsule shape can become a reusable CapsuleText view that accepts a text parameter
 - benefit: you can bake some modifiers into the custom view while leaving others (like foregroundStyle) to be applied at the call site, giving you both reusability and flexibility
 
 ** CUSTOM MODIFIERS **
 
 import SwiftUI
 
 struct Title: ViewModifier {
 func body(content: Content) -> some View {
 content
 .font(.largeTitle)
 .foregroundStyle(.white)
 .padding()
 .background(.blue)
 .clipShape(.rect(cornerRadius: 10))
 }
 }
 
 extension View {
 func titleStyle() -> some View {
 modifier(Title())
 }
 }
 
 struct Watermark: ViewModifier {
 var text: String
 
 func body(content: Content) -> some View {
 ZStack(alignment: .bottomTrailing) {
 content
 
 Text(text)
 .font(.caption)
 .foregroundColor(.white)
 .padding(5)
 .background(.black)
 }
 }
 }
 
 extension View {
 func watermarked(with text: String) -> some View {
 modifier(Watermark(text: text))
 }
 }
 
 struct ContentView: View {
 var body: some View {
 Color.blue
 .frame(width: 300, height: 200)
 .watermarked(with: "Hacking with Swift")
 }
 }
 
 #Preview {
 ContentView()
 }
 
 - custome modifiers let you package reusable styling logic into a named, composable unit
 - creating one: Make a struct conforming to ViewModifier and implement the body(content:) method, applying whatever modifiers you want to content and returning some View
 - using it: Apply via .modifier(MyModifier()), but the cleaner approach is to wrap it in a View extension so it reads like a native modifier: .titleStyle()
 
 - They're more powerful than plain methods: custom modifiers can create entirely new view structure (ex. wrapping content in a ZStack to add a watermark overlay) - not just chain existing modifiers
 - key advantage over View extensions: Custom ViewModifier strcuts can hold stored properties, which plain View extensions cannot. that the primary reason to reach for a custom modifier over a simple extension metho
