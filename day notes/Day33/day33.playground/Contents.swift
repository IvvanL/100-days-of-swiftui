// ** DAY 33 - PROJECT 6 - ANIMATIONS - PART 2 **

// ** CONTROLLING THE ANIMATON STACK **

/*
 import SwiftUI

 struct ContentView: View {
     @State private var enabled = false
     
     
     var body: some View {
         Button("Tap Me") {
             enabled.toggle()
         }
         .frame(width: 200, height: 200)
         .background(enabled ? .blue : .red)
         .foregroundStyle(.white)
         .animation(.default, value: enabled)
         .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
         .animation(.spring(duration: 1, bounce: 0.6), value: enabled)
     }
 }

 #Preview {
     ContentView()
 }

 */

// - 2 key concepts combined:
// 1. modifier order matters - SwiftUI wraps views in the order modifiers are applied
// 2. the animation() modifier animates any changes that come before it

// core rule: only modifiers placed before an animation() call get animated by it

// Multiple animation() modifiers - each one controls everything between itslef and the previous animation() modifier, letting you animate different properties differently:
//  + use .animation(.default, value:) for one property
//  + use .animation(.spring(...), value:) for another
//  + use .animation(nil, value:) to disable animation entirely for specific properties

// example pattern:
/*
 .background(enabled ? .blue : .red)
 .animation(.default, value: enabled)        // animates color
 .clipShape(.rect(cornerRadius: enabled ? 60 : 0))
 .animation(.spring(duration: 1, bounce: 0.6), value: enabled)  // animates shape
 */

// Takeaway: you can split a single state change into multiple animation segments with fine-grained control over each one



// ** ANIMATING GESTURES **

/*
import SwiftUI

struct ContentView: View {
    @State private var dragAmount = CGSize.zero
    
    
    var body: some View {
        LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(.rect(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.bouncy) {
                            dragAmount = .zero
                        }
                    }
            )
    }
}

#Preview {
    ContentView()
}
*/


/*
 import SwiftUI

 struct ContentView: View {
     let letters = Array("Hello SwiftUI")
     
     @State private var enabled = false
     @State private var dragAmount = CGSize.zero
     
     var body: some View {
         HStack(spacing: 0) {
             ForEach(0..<letters.count, id: \.self) { num in
                 Text(String(letters[num]))
                     .padding(5)
                     .font(.title)
                     .background(enabled ? .blue : .red)
                     .offset(dragAmount)
                     .animation(.linear.delay(Double(num) / 20), value: dragAmount)
             }
         }
         .gesture(
             DragGesture()
                 .onChanged { dragAmount = $0.translation }
                 .onEnded { _ in
                     dragAmount = .zero
                     enabled.toggle()
                 }
             )
     }
 }

 #Preview {
     ContentView()
 }
 */

// core idea: attach gestures to views and animate their effects - either implicitly or explicitly.

// Basic draggable card setup:
//  1. state variable: @State private var dragAmount = CDSize.zero
//  2. Apply position: .offset(dragAmount)
//  3. attach gesture

// .gesture(
//      DragGesture()
//          .onChanged { dragAmount = $0.translation }
//          .onEnded { _ in dragAMount = .zero }
//  )

// 2 animation approaches:

// + (1) - Implicit
//      +  how: .animation(.bouncy, value: dragAmount)
//      +  animates: both drag and release
//      +  Feel: slight delay + overshot while dragging

// + (2) - Explicit
//      + how: withAnimation(.bouncy) { dragAmount = .zero }
//      + animates: Release only
//      + Feel: instant follow, smooth snap back

// trick: Staggered letter animations:
//  + convert a striong to a character array with Array("Hello SwiftUI")
//  + give each letter the same offset, but add an incremental .delay() to each ones animation

// .animation(.linear.delay(Double(num) / 20), values: dragAmount)

// this creates a snake-like follow effect where each letter trails the ones before it

// takeaway: combining offset, DragGesture, and per-element animation delays lets you build expressive animations with very little code





// ** SHOWING AND HIDING VIEWS WITH TRANSITIONS **

/*
 import SwiftUI

 struct ContentView: View {
     @State private var isShowingRed = false
     
     var body: some View {
         VStack {
             Button("Tap me") {
                 withAnimation {
                     isShowingRed.toggle()
                 }
             }
             
             if isShowingRed {
                 Rectangle()
                     .fill(.red)
                     .frame(width: 200, height: 200)
                     .transition(.asymmetric(insertion: .scale, removal: .opacity))
             }
         }
     }
 }

 #Preview {
     ContentView()
 }

 */

// core idea: use if conditions to insert/remove views, and transition() to control how they appear and disappear

// Basic Setup:
//  1. state variable: @State private var isShowingRed = false
//  2. conditionally show view with ifSHowingRed { ... }
//  3. Toggle state inside withAnimation {} to get animated transitions

// Built-in transitions:
// Modifier - .transition(.scale)       effect - scales up on insert, down on remove
// Modifier - .transition(.opacity)     effect - Fadesin/out
// Modifier - .transition(.slide)       effect - Slides in/out

// Asymmetric transitions - use different animations for insert VS removal:
// .transition(.asymmetric(insertion: .scale, removal: .opacity))

// Key rules:
//  + without withAnimation {}, views appear/disappear abruptly
//  + the transition() modifier goes on the view being shown/hidden, not the parent
//  + transitions only trigger when views are added to or removed from the hierarchy (via if conditions), not just when they change

// Takeaway: Wrap state changes in withAnimation {} and attach .transition() to the target view for full control over how it enters and exits



// ** BUILDING CUSTOM TRANSITIONS USING VIEWMODIFIER **

/*
 import SwiftUI

 struct CornerRotateModifier: ViewModifier {
     let amount: Double
     let anchor: UnitPoint
     
     func body(content: Content) -> some View {
         content
             .rotationEffect(Angle(degrees: amount), anchor: anchor)
             .clipped()
     }
     
 }

 extension AnyTransition {
     static var pivot: AnyTransition {
         .modifier(
             active: CornerRotateModifier(amount: -90, anchor: .topLeading),
             identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
         )
     }
 }

 struct ContentView: View {
     @State private var isShowingRed = false
     
     var body: some View {
         ZStack {
             Rectangle()
                 .fill(.blue)
                 .frame(width: 200, height: 200)
             
             if isShowingRed {
                 Rectangle()
                     .fill(.red)
                     .frame(width: 200, height: 200)
                     .transition(.pivot)
             }
         }
         .onTapGesture {
             withAnimation {
                 isShowingRed.toggle()
             }
         }
     }
 }

 #Preview {
     ContentView()
 }

 */

// core idea: create custom transitions using ViewModifier + .modifier transition, then expose them cleanly via an AnyTransition extension.

// 3 step pattern:
//  1. Create a ViewModifier with the desired effect:

/*
 struct CornerRotateModifier: ViewModifier {
     let amount: Double
     let anchor: UnitPoint

     func body(content: Content) -> some View {
         content
             .rotationEffect(.degrees(amount), anchor: anchor)
             .clipped() // prevents drawing outside the view's bounds
     }
 }
 */

//  2. wrap it in an AnyTransition extension - define active (transition state) and identity (resting state):

/*
 extension AnyTransition {
     static var pivot: AnyTransition {
         .modifier(
             active: CornerRotateModifier(amount: -90, anchor: .topLeading),
             identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
         )
     }
 }
 */

//  3. apply it like any built-in transition:

/*
 .transition(.pivot)
 */

// Key concepts:
//  + rotationEffect() - 2D rotation with a controllable anchor point (UnitPoint)
//  + clipped() - prevents the view from drawing outside its frame during animation
//  + active = how the view looks while transition in/out
//  + identity - how the view looks at rest

// Takeaway: any ViewModifier can become a reusable custom transition. Wrapping it in an AnyTransition extension kleeps call sites clean dna idiomatic
