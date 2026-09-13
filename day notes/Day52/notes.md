#Day 52 - Cupcake Corner - Project 10 Challenge

1. Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.

2. If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.

3. For a more challenging task, try updating the Order class so it saves data such as the user's delivery address to UserDefaults. This takes a little thinking, because @AppStorage won't work here, and you'll find getters and setters cause problems with Codable support. Can you find a middle ground?

A 3-part challenge extending the Cupcake Corner app from Hacking with Swift's 100 Days of SwiftUI.

---

## 1. Whitespace-Only Address Validation

**Problem:** `hasValidAddress` only checked `.isEmpty`, so a field containing just spaces (`"   "`) was treated as valid.

**Fix:** Trim whitespace from each field before checking emptiness, using `trimmingCharacters(in:)`.

**File:** `Order.swift`

```swift
var hasValidAddress: Bool {
    if name.trimmingCharacters(in: .whitespaces).isEmpty ||
        streetAddress.trimmingCharacters(in: .whitespaces).isEmpty ||
        city.trimmingCharacters(in: .whitespaces).isEmpty ||
        zip.trimmingCharacters(in: .whitespaces).isEmpty {
        return false
    }

    return true
}
```

**Key idea:** `trimmingCharacters(in:)` returns a *new* trimmed string — it doesn't mutate the original. Check emptiness on the trimmed result, not the raw field.

---

## 2. Showing an Alert on Failed Checkout

**Problem:** If `placeOrder()` failed (e.g. no internet), the error was only printed to the console — the user saw nothing.

**Fix:** Reuse the existing `confirmationMessage` / `showingConfirmation` alert state for both success and failure, and add a `confirmationTitle` so the alert title also changes dynamically ("Thank you!" vs "Oh No!").

**File:** `CheckoutView.swift`

```swift
@State private var confirmationMessage = ""
@State private var showingConfirmation = false
@State private var confirmationTitle = ""

// ...

.alert(confirmationTitle, isPresented: $showingConfirmation) {
    Button("OK") {}
} message: {
    Text(confirmationMessage)
}

// ...

func placeOrder() async {
    guard let encoded = try? JSONEncoder().encode(order) else {
        print("Failed to encode order")
        return
    }

    let url = URL(string: "https://reqres.in/api/cupcakes")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"

    do {
        let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

        let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
        confirmationTitle = "Thank you!"
        confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
        showingConfirmation = true
    } catch {
        confirmationTitle = "Oh No!"
        confirmationMessage = "Check out failed! Try Again!"
        showingConfirmation = true
    }
}
```

**Testing tip:** Comment out `request.httpMethod = "POST"` to force the request to fail, confirming the "Oh No!" alert appears. Remember to uncomment it afterward.

---

## 3. Persisting the Order to UserDefaults

**Problem:** `@AppStorage` doesn't work on a custom `Codable`/`@Observable` class, and adding `didSet` to every property to trigger a save is messy and repetitive.

**Fix:** Add a `save()` method that encodes the whole `Order` and writes it to `UserDefaults`, and a custom `init()` that attempts to decode and restore saved data on launch. Trigger `save()` manually at a sensible moment — in this case, when the user leaves `AddressView`.

**File:** `Order.swift`

```swift
init() {
    if let savedOrder = UserDefaults.standard.data(forKey: "Order") {
        if let decodedOrder = try? JSONDecoder().decode(Order.self, from: savedOrder) {
            type = decodedOrder.type
            quantity = decodedOrder.quantity
            specialRequestEnabled = decodedOrder.specialRequestEnabled
            extraFrosting = decodedOrder.extraFrosting
            addSprinkles = decodedOrder.addSprinkles
            name = decodedOrder.name
            streetAddress = decodedOrder.streetAddress
            city = decodedOrder.city
            zip = decodedOrder.zip
        }
    }
}

func save() {
    if let encoded = try? JSONEncoder().encode(self) {
        UserDefaults.standard.set(encoded, forKey: "Order")
    }
}
```

**File:** `AddressView.swift`

```swift
.onDisappear {
    order.save()
}
```

**Key ideas:**
- `UserDefaults` can only store simple types directly, so the `Order` object must be encoded to `Data` (via `JSONEncoder`) before saving, and decoded back (via `JSONDecoder`) when loading.
- The custom `init()` tries to load saved data; if none exists or decoding fails, the normal default property values are used automatically since nothing overwrites them.
- Saving on every keystroke would be wasteful — `.onDisappear` on `AddressView` was chosen as a practical middle ground, saving once when the user navigates away from the address form.

---

## Debugging Notes

When the "did it save?" behavior wasn't obvious, temporary `print()` statements in both `save()` and `init()` were used to confirm:
- Whether `.onDisappear` actually fired (`"onDisappear called, saving order"`)
- Whether encoding succeeded (`"Order saved successfully"`)
- Whether decoding on relaunch succeeded (`"Order loaded successfully"` vs `"Failed to decode"` vs `"No saved order found"`)

This confirmed both the save and load paths worked correctly — the print statements should be removed once everything is verified working.
