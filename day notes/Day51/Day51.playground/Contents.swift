// ** DAY 51 CUPCAKE CORNER, PROJECT 10 PART 3 **

// ** CHECKING FOR A VALID ADDRESS **

/*
 * Create a **`CheckoutView`** that receives the same `Order` object as `AddressView`.

 * Add delivery address properties to the `Order` class:

   * `name`
   * `streetAddress`
   * `city`
   * `zip`

 * Use a **`Form`** in `AddressView` with `TextField`s bound to the `Order` properties.

 * Add a **`NavigationLink`** to move to `CheckoutView`.

 ### Why `@Bindable` is needed

 Because `AddressView` receives the `Order` object instead of creating it with `@State`, use:

 @Bindable var order: Order

 `@Bindable` creates the **two-way bindings** needed to use `$order.name`, `$order.city`, etc., with an `@Observable` class.

 ### Shared Data Between Views

 Passing the same `Order` object through multiple views means all views share the same data. Information entered on one screen remains available when navigating backward and forward.

 ### Address Validation

 Add a computed property inside `Order` to check that all fields contain data:

 var hasValidAddress: Bool {
     if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
         return false
     }

     return true
 }

 ### Preventing Invalid Navigation

 Use `.disabled()` on the checkout section:


 .disabled(order.hasValidAddress == false)
 
 This prevents the user from continuing until all address fields contain text. SwiftUI automatically grays out the **Check out** button when it is disabled.

 ### Key Concepts

 * `@Bindable` creates bindings for an `@Observable` object received from another view.
 * A shared class allows data to persist across navigation.
 * Computed properties are useful for keeping validation logic inside the data model.
 * `.disabled()` prevents interaction when a condition is not satisfied and automatically provides visual feedback.
*/


// ** PREPARING FOR CHECKOUT **

/*
 ### CheckoutView UI

 The final screen is **`CheckoutView`**, which displays:

 * A remotely loaded cupcake image
 * The total cost of the order
 * A **Place Order** button
 * Networking functionality will be added later

 ### Calculating the Order Cost

 Add a computed `cost` property to the `Order` class:

 var cost: Decimal {
     var cost = Decimal(quantity) * 2

     // More complicated cupcake types cost more
     cost += Decimal(type) / 2

     // $1 extra per cupcake for extra frosting
     if extraFrosting {
         cost += Decimal(quantity)
     }

     // $0.50 extra per cupcake for sprinkles
     if addSprinkles {
         cost += Decimal(quantity) / 2
     }

     return cost
 }


 **Pricing:**

 * Base price: **$2 per cupcake**
 * More complicated cupcake types cost extra
 * Extra frosting: **+$1 per cupcake**
 * Sprinkles: **+$0.50 per cupcake**

 Using a computed property keeps all pricing logic inside the `Order` model.

 ---

 ### Loading a Remote Image with `AsyncImage`

 Use `AsyncImage` to load an image from the internet:

 AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
     image
         .resizable()
         .scaledToFit()
 } placeholder: {
     ProgressView()
 }
 .frame(height: 233)


 `AsyncImage`:

 * Downloads images asynchronously from a URL.
 * Shows the image when it successfully loads.
 * Displays a `ProgressView` while loading.
 * Allows remote images to be changed without updating the app.

 ---

 ### Displaying Currency

 Format the `Decimal` price as USD:

 Text("Your total is \(order.cost, format: .currency(code: "USD"))")
     .font(.title)

 SwiftUI automatically formats the value as currency.

 ---

 ### Preventing Unnecessary Scroll Bounce

 Use:

 .scrollBounceBehavior(.basedOnSize)

 This makes the `ScrollView` bounce **only when its content is large enough to scroll**. If everything fits on the screen, the unnecessary bounce is removed.

 ---

 ### Key Concepts

 * Use **`Decimal`** for monetary values.
 * Use **computed properties** to keep pricing logic inside your data model.
 * Use **`AsyncImage`** to load remote images asynchronously.
 * Use a **`ProgressView`** as a loading placeholder.
 * Use `.currency(code:)` to format prices.
 * Use `.scrollBounceBehavior(.basedOnSize)` for better scrolling behavior.
*/

// ** SENDING AND RECEIVING ORDERS OVER THE INTERNET **

/*

 **Goal:** Use `URLSession` + `Codable` to send an order as JSON to a server and handle the response, all in an async `placeOrder()` function.

 ## Key Steps

 **1. Calling async code from a Button**
 Buttons can't call `async` functions directly. Wrap the call in a `Task`:

 Button("Place Order") {
     Task {
         await placeOrder()
     }
 }

 **2. Encode the order to JSON**
 
 guard let encoded = try? JSONEncoder().encode(order) else {
     print("Failed to encode order")
     return
 }
 
 Requires `Order` to conform to `Codable`.

 **3. Build the request**
 Use `URLRequest` to specify:
 - **HTTP method** — `POST` (writing data) vs `GET` (reading data)
 - **Content-Type** — MIME type, here `application/json`

 let url = URL(string: "https://reqres.in/api/cupcakes")!
 var request = URLRequest(url: url)
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.httpMethod = "POST"

 (reqres.in is a test API that echoes back whatever you send — useful for prototyping.)

 **4. Send the request**
 
 do {
     let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
     // handle result
 } catch {
     print("Checkout failed: \(error.localizedDescription)")
 }

 **5. Decode the response & show confirmation**
 Add state properties:
 
 @State private var confirmationMessage = ""
 @State private var showingConfirmation = false
 
 Attach an `.alert()` modifier, then decode and confirm:
 
 let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
 confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
 showingConfirmation = true

 ## Debugging Tip
 Set a breakpoint and use LLDB command `p String(decoding: encoded, as: UTF8.self)` to inspect the raw JSON being sent.

 ## Gotcha: `@Observable` property names
 The `@Observable` macro renames properties with underscores internally (e.g., `_type`), so encoded JSON uses ugly keys. reqres.in doesn't care since it just echoes data back, but real servers do. Fix with custom `CodingKeys`:
 
 enum CodingKeys: String, CodingKey {
     case _type = "type"
     case _quantity = "quantity"
     case _specialRequestEnabled = "specialRequestEnabled"
     case _extraFrosting = "extraFrosting"
     case _addSprinkles = "addSprinkles"
     case _name = "name"
     case _city = "city"
     case _streetAddress = "streetAddress"
     case _zip = "zip"
 }

 This maps each underscored property to a clean JSON key name.

*/
