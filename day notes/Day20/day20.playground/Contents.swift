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
 
 - background color - use .background(.red) on a view to color only that view. To fill an entire area, place Color.red as a standalone view inside a ZStack
 - Sizing Colors - colors fill all available space by default. Use .frame() to constrain them (ex. width: 200, height: 200), including min/max values
 - Built-in colors - Color.blue, .green, .indigo, etc.
 + semantic colors like Color.primary and Color.secondary adapt to light/dark mode automatically.
 + Custom colors: Color(red:green:blue:) with values 0-1.
 - Safe area - colors stop at the safe area by default (dynamic island, home indicator). Use .ignoresSafeArea() to extend to screen edges - fine for decorative content, never for important content.
 - Materials(frosted glass) - pass a material like .ultraThinMaterial to .background() tocreate a frosted glass effect. Adapts to light/dark mode. Paired with .foregroundStyle(.secondary), text gets vibrancy - subtly picking up background colors to stay legible
 
 **GRADIENTS**
 
 import SwiftUI
 
 struct ContentView: View {
 var body: some View {
 Text("YOUR CONTENT")
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 .foregroundStyle(.white)
 .background(.red.gradient)
 }
 }
 
 #Preview {
 ContentView()
 }
 
 - SwiftUI has 4 gradient types, most of which work as standalone views or modifiers (ex. .background)
 
 1. Linear Gradient
 + goes in one direction(start-> endpoint)
 + LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
 + use stops for sharper transitions, specifying a color + position (0.0=1.0)
 + LinearGradient(stops: [
 .init(color: .white, location: 0.45),
 .init(color: .black, location: 0.55),
 ], startPoint: .top, endPoint: .bottom)
 
 2. Radial Gradient
 + radiates outward in a circle. Set center = Start/end radius
 +  RadialGradient(colors: [.blue, .black], center: .center, startRadius: 20, endRadius: 200)
 
 3. Angular(conic) Gradient
 + AngularGradient(colors: [.red, .yellow, .green, .blue, .purple, .red], center: .center)
 
 4. .gradient modifier(simplest)
 + appends a sublte linear gradient to any color. only usable as a background/foreground style, not a standalone view
 + .background(.red.gradient)
 
 - Types 1–3 support gradient stops and work as standalone views or modifiers
 - Type 4 is automatic and subtle — great for quick design polish
