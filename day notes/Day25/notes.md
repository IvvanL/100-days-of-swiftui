# Day 25 Notes - Milestone: Projects 1-3 - Complete

- RECAP:
+ Building scrolling forms that mix text with controls such as Picker, which SwiftUI turns into a beautiful table-based layout where new screens slide in with fresh choices.
+ Creating a NavigationStack and giving it a title. This not only allows us to push new views onto the screen, but also lets us set a title and avoid problems with content going under the clock.
+ How to use @State to store changing data, and why it’s needed. Remember, all our SwiftUI views are structs, which means they can’t be changed without something like @State.
+ Creating two-way bindings for user interface controls such as TextField and Picker, learning how using $variable lets us both read and write values.
+ Using ForEach to create views in a loop, which allows us to make lots of views all at once.
+ Building complex layouts using VStack, HStack, and ZStack, as well as combining them together to make grids.
+ How to use colors and gradients as views, including how to give them specific frames so you can control their size.
+ How to create buttons by providing some text or an image, along with a closure that should be executed when the button is tapped.
+ Creating alerts by defining the conditions under which the alert should be shown, then toggling that state from elsewhere.
+ How (and why!) SwiftUI uses opaque result types (some View) so extensively, and why this is so closely linked to modifier order being important.
+ How to use the ternary conditional operator to create conditional modifiers that apply different results depending on your program state.
+ How to break up your code into small parts using view composition and custom view modifiers, which in turn allows us to build more complex programs without getting lost in code.

- KEY POINTS:
+ Structs vs Classes
    1. classes dont come with a memberwise initializer; structs get these by default
    2. classes can use inheritance to build up functionality; struct cannot
    3. if you copy a class, both copies point to the same data; copies of struct are always unique
    4. classes can have deinitializers; struct cannot
    5. you can change variable properties inside constant classes; properties inside constant structs are fixed regardless of whether the properties are constants or variables
    
- WORKING WITH ForEach:
+ ForEach(0..<100) { number in
    Text("Row \(number)")
    }
    
    - ForEach is a view, but it allows us to create other views inside a loop
    - consider the array below:
    
    let agents = ["Cyril", "Lana", "Pam", "Sterling"]
    
    - how can we loop over those and make text views?
    - one option is to use the same construction we already have:
    
    VStack {
        ForEach(0..<agents.count) {
            Text(agents[$0])
    }
}

    - second option is better - we can loop over the array directly, shown below.
    
    VStack {
        ForEach(agents, id: \.self) {
            Text($0)
    }
}
    - rather than loop over integers, we read items in the array directly

- WORKING WITH BINDINGS:
+ simplest form of custom binding, stores the value away in another @State property and reads it back:

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        let binding = Binding(
            get: { selection },
            set: { selection = $0 }
    )
    
        return VStack {
            Picker("Select a number", selection: binding) {
                ForEach(0..<3) {
                    Text("Item \($0)")
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

    - the binding above, just acting as a passthrough - doesnt store or calculate any data itself
    - picker is now made using selection: binding - no dollar sign required. we dont need to explicitly ask for two-way binding here because it already is one
    
- we can create a more advanced binding that does more than just pass through a single value
- for ex., a form with 3 toggle switches:
    1. does the user agree to terms and conditions
    2. agree to the privacy policy
    3. agree to get emails about shipping
- we might represent it as a 3 boolean @state properties:

@State var agreedToTerms = false
@State var agreedToPrivacyPolicy = false
@State var agreedToEmails = false

- eventhough the user could toggle them by hand, we can use a custom binding to do them all at once. the binding below would be true if all 3 of those booleans were true, but if it got changed then it would  update them all:

let agreedToAll = Binding(
    get: {
        agreedToTerms && agreedToPrivacyPolicy && agreedToEmails
},

    set: {
        agreedToTerms = $0
        agreedToPrivacyPolicy = $0
        agreedToEmails = $0
    }
)

- now we can create four toggle switches: one each for the individual booleans, and one control switch that agrees or disagrees to all 3 at once:

struct ContentView: View {
    @State private var agreedToTerms = false
    @State private var agreedToPrivacyPolicy = false
    @State private var agreedToEmails = false

    var body: some View {
        let agreedToAll = Binding<Bool>(
            get: {
                agreedToTerms && agreedToPrivacyPolicy && agreedToEmails
            },
            set: {
                agreedToTerms = $0
                agreedToPrivacyPolicy = $0
                agreedToEmails = $0
            }
            
        )
        
        return VStack {
            Toggle("Agree to terms", isOn: $agreedToTerms)
            Toggle("Agree to privacy policy", isOn: $agreedToPrivacyPolicy)
            Toggle("Agree to receive shipping emails", isOn: $agreedToEmails)
            Toggle("Agree to all", isOn: $agreedToAll)
        }
    }
}

- Normally body doesn't need return, but when you declare a let inside body first, Swift requires an explicit return so it knows where the view starts

CHALLENGE: challenge is to make a brain training game that challenges players to win or lose at rock, paper, scissors.

1. Each turn of the game the app will randomly pick either rock, paper, or scissors.
2. Each turn the app will alternate between prompting the player to win or lose.
3. The player must then tap the correct move to win or lose the game.
4. If they are correct they score a point; otherwise they lose a point.
5. The game ends after 10 questions, at which point their score is shown.

