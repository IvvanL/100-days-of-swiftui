# Day 21 Notes - Project 2: Guess the Flag, Part 2 complete

- In this second SwiftUI project we’re going to be building a guessing game that helps users learn some of the many flags of the world.
- introduce you to whole range of new SwiftUI functionality: stacks, buttons, images, alerts, asset catalogs, and more.

- learned about stacking up buttons
- How to show the players score with an alert
- stylization of flags
- upgraded app design with different modifires, padding etc
- learned about using different iphone templates to make it a more polished universal layout/design that works on all/most devices

summary of modifiers & concepts learned:

+ Text Modifiers 
.font(.subheadline.weight(.heavy)) — small bold text
.font(.largeTitle.weight(.semibold)) — large prominent text
.font(.largeTitle.bold()) — shortcut for bold
.foregroundStyle(.white) — white text
.foregroundStyle(.secondary) — iOS vibrancy/secondary color
.foregroundStyle(.primary) — defaults to black/white based on mode

+ Image Modifiers
.clipShape(.capsule) — rounds shortest edges
.clipShape(.rect(cornerRadius: 20)) — rounded rectangle
.shadow(radius: 5) — subtle drop shadow

+ Layout Modifiers
.frame(maxWidth: .infinity) — stretch to full width
.padding(.vertical, 20) — vertical padding only
.padding() — padding on all sides
.background(.regularMaterial) — frosted glass card effect
Spacer() — pushes content apart, scales by screen size

+ Gradients
LinearGradient(colors:startPoint:endPoint:) — smooth color blend
RadialGradient(stops:center:startRadius:endRadius:) — circular gradient
.init(color:location:) — gradient stop, same location = hard edge

+ State & Logic
@State private var — makes variables trigger UI updates
.shuffled() — randomizes array order
Int.random(in: 0...2) — random integer in range
.alert(isPresented:) — shows a popup alert
$variable — two-way binding to a state variable
