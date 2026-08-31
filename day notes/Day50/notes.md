#Day 50 - Cupcake Corner - Project 10, part 2 - completed

## 1. Codable Conformance with @Observable Classes
- `@Observable` renames stored properties (`name` → `_name`) and adds `_$observationRegistrar`, which leaks into JSON:
  ```json
  {"_name":"Taylor","_$observationRegistrar":{}}
  ```
- **Fix:** map the underscored property back to a clean key using `CodingKeys`:
  ```swift
  @Observable
  class User: Codable {
      enum CodingKeys: String, CodingKey {
          case _name = "name"
      }
      var name = "Taylor"
  }
  ```
- Works both ways — encoding produces clean JSON, and decoding JSON with `"name"` correctly populates `_name`.

---

## 2. Adding Haptic Effects
- Only works on **physical iPhones** (not simulators/Mac/iPad).

**Easy option:**
```swift
.sensoryFeedback(.increase, trigger: counter)
```
- Variants: `.increase`, `.success`, `.warning`, `.error`, `.start`, `.stop`, etc.
- ⚠️ Use semantically correct variants — some users rely on haptics for meaning.

**More control:**
```swift
.sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
.sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
```

**Advanced — Core Haptics:**
```swift
import CoreHaptics

@State private var engine: CHHapticEngine?

func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
    do {
        engine = try CHHapticEngine()
        try engine?.start()
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

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
```
- Call `prepareHaptics()` via `.onAppear`.
- Vary `relativeTime` across multiple events to build custom multi-tap sequences.
- **Takeaway:** stick with `.sensoryFeedback()` unless you need very specific custom effects.

---

## 3. Cupcake Corner — Taking Basic Order Details

**Shared data model** — one `@Observable` class instance passed across all screens:
```swift
@Observable
class Order {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false
    var extraFrosting = false
    var addSprinkles = false
}
```
```swift
@State private var order = Order()
```

**UI — 3 form sections in a `NavigationStack`:**

1. **Cake type & quantity**
   ```swift
   Section {
       Picker("Select your cake type", selection: $order.type) {
           ForEach(Order.types.indices, id: \.self) {
               Text(Order.types[$0])
           }
       }
       Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
   }
   ```
   - Uses `.indices` to map the string array to an int selection (safe only for immutable/static arrays).

2. **Special requests toggles**
   ```swift
   Section {
       Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

       if order.specialRequestEnabled {
           Toggle("Add extra frosting", isOn: $order.extraFrosting)
           Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
       }
   }
   ```
   - **Bug:** disabling special requests doesn't reset frosting/sprinkles — stale values persist.
   - **Fix:** reset dependent values with `didSet`:
     ```swift
     var specialRequestEnabled = false {
         didSet {
             if specialRequestEnabled == false {
                 extraFrosting = false
                 addSprinkles = false
             }
         }
     }
     ```

3. **Navigation to next screen**
   ```swift
   Section {
       NavigationLink("Delivery details") {
           AddressView(order: order)
       }
   }
   ```
   - Placeholder next screen:
     ```swift
     struct AddressView: View {
         var order: Order

         var body: some View {
             Text("Hello World")
         }
     }
     ```

**Key takeaway:** A single shared `@Observable` instance passed via `NavigationLink` keeps every screen in sync. `didSet` observers help enforce data consistency between interdependent properties.
```
