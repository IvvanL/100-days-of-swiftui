// ** DAY 32 - PROJECT 6 - ANIMATIONS - PART 1 **

// ** CREATING IMPLICIT ANIMATIONS **

/*
import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.default, value: animationAmount)
    }
}

#Preview {
    ContentView()
}
*/

// core concept - declare how a view should animate ahead of time. SwiftUI handles the rest automatically. animation becomes a function of state, not manual frame control

// Key components:
// + @State variable to drive the animaton (ex. animationAmount)
// + .scaleEffect(animationAmount) - scales the view based on state
// + .animation(.default, value: animationAmount) - triggers animation whenever that value changes

// How it works:
// 1. attach .animation() to a view with a watched value
// 2. any property that changes when that value changes gets animated automatically - scale, blue, color, etc\
// 3. you never specify keyframes or timning manually

// Example modifiers used:
// - .scaleEffect() - resizes the view (1.0 = 100%)
// - .blur(radius:) - adds Gaussian blur; place it before .animation()

// key insight: all animatable modifiers on the view animate together implicitly - you just change state and SwiftUI figures out the transition

// ** CUSTOMIZING ANIMATIONS IN SWIFTUI **

/*
import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        Button("Tap me") {
            //           animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(.circle)
        //        .scaleEffect(animationAmount)
        //        .blur(radius: (animationAmount - 1) * 3)
        //      .animation(.spring(duration: 1, bounce: 0.5), value: animationAmount)
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount)
                .opacity(2 - animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                    value: animationAmount)
        )
        .onAppear {
            animationAmount = 2
        }
    }
}

#Preview {
    ContentView()
}
*/

// Animation types (passed to .animation() ):
// + .default - gentle spring(slow start, slight overshoot)
// + .linear - constant speed
// + .spring(duration:, bounce:) - customizable bounce(0= none, 1=max)
// + .easeInOut(duration:) - slowin, slow out with set duration)

// Animation modifiers(chained onto the animation itself):
// + .delay(1) - waits N seconds before starting
// + .reapeatCount(3, autoreverses: true) - repeats N times, optionally bouncing back
// + .repeatForever(autoreverses:) - loops indefinitely

// Important note: when an animation finishes, the view must match the actual state value - animations dont override state.

// Pulsing effect pattern (continuous animation on appear):
// 1. use . overlay() to palce an animated circle over a button
// 2. tie scale + opacity to animationAmount
// 3. apply .repeatForever(autoreverses: false) to the overlay
// 4. use .onAppera { animationAmount = 2 } to kick it off automatically


// ** ANIMATING BINDINGS **

/*
import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 1.0
    
    var body: some View {
        print(animationAmount)
        
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(
                .easeInOut(duration: 1)
                .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("tap me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .scaleEffect(animationAmount)
        }
    }
}

#Preview {
    ContentView()
}
*/

// Core idea: apply .animation() directly to a binding (ex. $animationAmount.animation()) instead of to a view. SwiftUI animates the view changes that result from the state change - not the value itself

// how it works: SwiftUI snapshots the view before and after the binding changes, then animateds the transition between them. This is why even booleans can be "animated" - its animating the resulting view changes, not inventing in-between values

// Syntax: Stepper("Scale amount", value: $animationAmount.animation(), in: 1...10)
// with custom animation:
// $animationAmount.animation(.easeInOut(duration: 1).repeatCount(3, autoreverses: true))

// the code exmaple showed - the stepper used $animationAmount.animation(), so it animated smoothly, while the button changed animationAmount direclty and jumped instantly. Same state variable, same view, different behavior based on wehre the animation was defined

// ** CREATING EXPLICIT ANIMATIONS **

/*
import SwiftUI

struct ContentView: View {
    @State private var animationAmount = 0.0
    
    var body: some View {
        Button("Tap Me") {
            withAnimation (.spring(duration: 1, bounce: 0.5)) {
                animationAmount += 360
            }
            }
            .padding(50)
            .background(.red)
            .foregroundStyle(.white)
            .clipShape(.circle)
            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
        }
    }

#Preview {
    ContentView()
}
*/

// core idea: wrap state changes in withAnimation{} to explicitly tell SwiftUI to animate whatever view changes result from that state change. not attached to a view or a binding - just a direct request to animate

// rotation3DEffect() - new modifier introduced:
// .rotation3DEffect(.degrees(animationAMount), axis: (x: 0, y: 1, z: 0))

// X axis -> spins forwards/backwards
// Y axis -> spins left/right
// Z axis -> rotates clockwise/counterclockwise

// implicit - the view via .animation()
// binding - the binding via $value.animation()
// explicit - the state change via withAnimation { }
