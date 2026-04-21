import Cocoa

/*
 
 **DAY 20: Project 2: GUESS THE FLAG**
 
 **USING STACKS TO ARRANGE VIEWS**
 - there are 3 manin stacks in SwiftUI
 + VStack (vertical)
 + HStack (horizontal)
 + ZStack (depth/overlap)
 
 - VStack and HStack both support spacing and alignment parameters
 - Spacer() to push content to one side - multiple spacers divide space equally between them
 - ZStack draws views back to front (no spacing, but supports alignment)
 - Swift UI can infer a VStack without explicitly writing one, but being explicit gives you more control
 
 **COLORS AND FRAMES**
 
 import SwiftUI
 
 struct ContentView: View {
 var body: some View {
 ZStack {
 VStack(spacing: 0) {
 Color.red
 Color.blue
 }
 
 Text("Your Content")
 .foregroundStyle(.secondary)
 .padding(50)
 .background(.ultraThinMaterial)
 }
 }
 }
 
 #Preview {
 ContentView()
 }
 
 SwiftUI: Colors & Frames
 
 - background color - use .background(.red) on a view to color only that view. To fill an entire area, place Color.red as a standalone view inside a ZStack
 - Sizing Colors - colors fill all available space by default. Use .frame() to constrain them (ex. width: 200, height: 200), including min/max values
 - Built-in colors - Color.blue, .green, .indigo, etc.
 + semantic colors like Color.primary and Color.secondary adapt to light/dark mode automatically.
 + Custom colors: Color(red:green:blue:) with values 0-1.
 - Safe area - colors stop at the safe area by default (dynamic island, home indicator). Use .ignoresSafeArea() to extend to screen edges - fine for decorative content, never for important content.
 - Materials(frosted glass) - pass a material like .ultraThinMaterial to .background() tocreate a frosted glass effect. Adapts to light/dark mode. Paired with .foregroundStyle(.secondary), text gets vibrancy - subtly picking up background colors to stay legible
