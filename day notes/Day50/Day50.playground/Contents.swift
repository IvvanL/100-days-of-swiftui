// ** DAY 50 PROJECT 10, PART 2 **

// ** ADDING CODABLE CONFORMANCE TO AN @OBSERVABLE CLASS **

/*
 **Problem:** With `@Observable` classes conforming to `Codable`, Swift's macro rewrites stored properties (e.g. `name` → `_name`) and adds an observation registrar. This leaks into JSON encoding, producing unexpected output like:
 
 json
 {"_name":"Taylor","_$observationRegistrar":{}}
 
 This breaks compatibility with servers/APIs expecting clean key names like `"name"`.

 **Fix:** Add a nested `CodingKeys` enum (String, CodingKey) that maps the underscored property to the desired key name:

 @Observable
 class User: Codable {
     enum CodingKeys: String, CodingKey {
         case _name = "name"
     }

     var name = "Taylor"
 }

 **Result:** Encoding/decoding now uses `"name"` correctly (no underscore, no registrar in output). The mapping works both directions — decoding JSON with `"name"` populates the `_name` storage property automatically.
*/

// **  ADDING HAPTIC EFFECTS **

/*
 Haptics only work on physical iPhones (not Mac/iPad simulators).

 **Easy option — `.sensoryFeedback()`**
 Simplest approach: attach a modifier to trigger built-in haptic patterns based on a state change.

 .sensoryFeedback(.increase, trigger: counter)

 - Built-in variants: `.increase`, `.success`, `.warning`, `.error`, `.start`, `.stop`, etc.
 - ⚠️ Accessibility note: use the *correct* semantic variant — blind users may rely on haptics for meaning, so don't play `.success` for an error just because you like the feel.

 **More control — `.impact()`**
 Lets you specify flexibility/weight and intensity:

 .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
 .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)

 **Advanced option — Core Haptics framework**
 For fully custom haptic patterns (taps, continuous vibration, parameter curves):
 1. `import CoreHaptics`
 2. Create an engine: `@State private var engine: CHHapticEngine?`
 3. Start it on appear:

 func prepareHaptics() {
     guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
     do {
         engine = try CHHapticEngine()
         try engine?.start()
     } catch {
         print("Error: \(error.localizedDescription)")
     }
 }

 4. Build events using `.hapticIntensity` and `.hapticSharpness` parameters, combine into a `CHHapticPattern`, and play via a `CHHapticPlayer`:

 func complexSuccess() {
     guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
     var events = [CHHapticEvent]()
     let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
     let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
     let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
     events.append(event)

     do {
         let pattern = try CHHapticPattern(events: events, parameters: [])
         let player = try engine?.makePlayer(with: pattern)
         try player?.start(atTime: 0)
     } catch {
         print("Failed to play pattern: \(error.localizedDescription).")
     }
 }

 - Use `.onAppear(perform: prepareHaptics)` to start the engine before triggering effects.
 - Sequences of events with varying `relativeTime` values can create complex multi-tap patterns (e.g., ramping intensity/sharpness up then down).

 **Takeaway:** Stick with `.sensoryFeedback()` for most use cases — Core Haptics is powerful but adds significant complexity, so it's best reserved for very specific/custom needs.
*/

// ** TAKING BASIC ORDER DETAILS **

/*

 **Data model — shared class**
 Instead of mixing structs/classes, use a single `@Observable` class to hold order data, passed across all screens so they share state:

 @Observable
 class Order {
     static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

     var type = 0
     var quantity = 3

     var specialRequestEnabled = false
     var extraFrosting = false
     var addSprinkles = false
 }


 Create one instance in `ContentView`:

 @State private var order = Order()
 
 This single instance gets passed to every other screen.

 **UI — built in 3 form sections inside a `NavigationStack`**

 1. **Cake type & quantity**
 
 Section {
     Picker("Select your cake type", selection: $order.type) {
         ForEach(Order.types.indices, id: \.self) {
             Text(Order.types[$0])
         }
     }
     Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
 }

 - Uses `.indices` to map the string array to an integer selection (safe here since the array order never changes; risky for mutable arrays).

 2. **Special requests toggles**
 
 Section {
     Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

     if order.specialRequestEnabled {
         Toggle("Add extra frosting", isOn: $order.extraFrosting)
         Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
     }
 }
 
 - **Bug:** disabling "special requests" doesn't reset the frosting/sprinkles toggles — their old values persist and reappear if re-enabled.
 - **Fix:** add a `didSet` observer to reset dependent toggles when disabled:
 
 var specialRequestEnabled = false {
     didSet {
         if specialRequestEnabled == false {
             extraFrosting = false
             addSprinkles = false
         }
     }
 }


 3. **Navigation to next screen**
 
 Section {
     NavigationLink("Delivery details") {
         AddressView(order: order)
     }
 }

 - Passes the shared `order` object to a new `AddressView`, created as a placeholder screen:
 
 struct AddressView: View {
     var order: Order

     var body: some View {
         Text("Hello World")
     }
 }
 

 **Key takeaway:** Using a single `@Observable` class instance shared across screens (via NavigationLink) keeps all views in sync with the same order data, and property observers (`didSet`) are a clean way to enforce data consistency when toggles are interdependent.
*/
