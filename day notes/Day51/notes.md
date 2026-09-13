#Day 51 - Cupcake Corner - Project 10, completed

## Part 1: Networking Basics & Form Validation
- **Codable + URLSession (GET):** Defined `Codable` structs matching JSON shape, fetched with `URLSession.shared.data(from:)`, decoded with `JSONDecoder`. Used `.task { }` (not `.onAppear`) to run async code when a view appears.
- **AsyncImage:** Loads remote images automatically (download + cache). Since dimensions aren't known ahead of time, sizing needs help:
  - Pass `scale:` to treat it as e.g. @3x.
  - Use the two-closure form (`image` + `placeholder`) so `.resizable()`/`.frame()` work correctly.
  - Full phase-control form (`phase.image` / `phase.error` / else `ProgressView()`) handles success/error/loading states separately.
- **Form validation:** `.disabled(condition)` disables buttons/sections until input is valid; cleaner to move the check into a computed property (e.g. `disableForm`). Disabled buttons auto-gray out.

## Part 2: Observable + Codable, Haptics, Order Model
- **`@Observable` + `Codable` conflict:** The macro renames properties (`name` → `_name`) and adds an observation registrar, which leaks into JSON. Fix with a custom `CodingKeys` enum mapping `_name` → `"name"`.
- **Haptics:** `.sensoryFeedback(.success, trigger:)` etc. is the easy option (physical device only); `.impact()` gives more control; Core Haptics (`CHHapticEngine`, `CHHapticEvent`, `CHHapticPattern`) enables fully custom patterns but adds complexity — stick to `.sensoryFeedback()` unless truly needed.
- **Shared Order model:** Single `@Observable` class (`Order`) created once with `@State` in `ContentView`, then passed to every subsequent screen so all views share the same data.
  - Built the first form section (cake type picker + quantity stepper) and special-request toggles.
  - Bug: turning off "special requests" didn't reset dependent toggles → fixed with a `didSet` observer on `specialRequestEnabled` that resets `extraFrosting`/`addSprinkles`.
  - Passed `order` via `NavigationLink` into a placeholder `AddressView`.

## Part 3: Address Validation, Checkout, Networking
- **AddressView:** Added `name`, `streetAddress`, `city`, `zip` to `Order`; built a `Form` with `TextField`s bound via `@Bindable var order: Order` (needed because the object is *received*, not created with `@State`).
- **Validation:** Computed `hasValidAddress` on `Order` checks all fields are non-empty; `.disabled(order.hasValidAddress == false)` blocks navigation to checkout until complete.
- **CheckoutView:** Shows remote cupcake image (`AsyncImage`), computed `cost` (base $2/cupcake + type + frosting $1 + sprinkles $0.50), formatted with `.currency(code: "USD")`, and `.scrollBounceBehavior(.basedOnSize)` to avoid unnecessary scroll bounce.
- **Sending orders over the network (POST):**
  - Wrap async calls from a Button in `Task { await placeOrder() }`.
  - Encode `Order` (must be `Codable`) with `JSONEncoder`.
  - Build a `URLRequest` with `httpMethod = "POST"` and `Content-Type: application/json`.
  - Send via `URLSession.shared.upload(for:from:)`, decode the echoed response, and show a confirmation `.alert()`.
  - Debug tip: LLDB `p String(decoding: encoded, as: UTF8.self)` to inspect outgoing JSON.
  - Gotcha: fix `@Observable`'s underscored property names for real servers using a full `CodingKeys` enum mapping every `_property` to its clean JSON key.

**Big picture takeaway:** A single shared `@Observable` model object, passed through screens via `@Bindable`/`NavigationLink`, keeps multi-screen form data in sync — and `Codable` + `CodingKeys` + `URLSession` round out sending/receiving that data over the network.
