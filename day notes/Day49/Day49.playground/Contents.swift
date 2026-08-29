// ** DAY 49 - CUPCAKE CORNER, PROJECT 10 PART 1**

/*
 In this project we’re going to build a multi-screen app for ordering cupcakes. This will use a couple of forms, which are old news for you, but you’re also going to learn how to send and receive the order data from the internet, how to validate forms, and more.
*/

// ** SENDING AND RECEIVING CODABLE DATA WITH URLSESSION AND SWIFTUI **

/*
 ## Goal
 Fetch JSON from Apple's iTunes Search API and display it in a SwiftUI `List` using `Codable`.

 ## 1. Define Codable models
 
 struct Response: Codable {
     var results: [Result]
 }

 struct Result: Codable {
     var trackId: Int
     var trackName: String
     var collectionName: String
 }
 ```

 ## 2. Basic view with empty state
 
 struct ContentView: View {
     @State private var results = [Result]()

     var body: some View {
         List(results, id: \.trackId) { item in
             VStack(alignment: .leading) {
                 Text(item.trackName).font(.headline)
                 Text(item.collectionName)
             }
         }
     }
 }
 ```

 ## 3. Async/await basics
 
 - **Async function**: can "sleep" while waiting on slow work (like networking) without freezing the app.
 - Mark functions with `async`; call them with `await` (like `try`, but for acknowledging a possible suspension).
 - Use `.task { }` modifier (not `.onAppear`) to call async functions when a view appears — `.task` supports async code natively.

 ## 4. Load data step-by-step
 
 func loadData() async {
     guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
         print("Invalid URL")
         return
     }

     do {
         let (data, _) = try await URLSession.shared.data(from: url)

         if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
             results = decodedResponse.results
         }
     } catch {
         print("Invalid data")
     }
 }
 ```
 Call it via:
 
 .task {
     await loadData()
 }
 ```

 ## Key points
 - `URLSession.shared.data(from:)` returns a tuple `(Data, URLResponse)`; often only the data is needed (metadata discarded with `_`).
 - Must write `try await` (not `await try`) when both are needed.
 - `JSONDecoder().decode(Response.self, from: data)` converts raw `Data` into your Swift model.
 - This covers **downloading only**; sending Codable data (POST requests) is a separate topic.
 
*/

//** LOADING AN IMAGE FROM A REMOTE SERVER **

/*
 **Basic use:** `AsyncImage(url:)` loads a remote image, handling downloading, caching, and display automatically — unlike bundled `Image`, which uses precompiled asset scales.

 **Sizing issue:** Since SwiftUI doesn't know the image dimensions until it's downloaded, it can't size it properly ahead of time (renders at native pixel size, often too large/blurry).

 **Fix 1 — Set scale manually:**
 
 AsyncImage(url: URL(string: "..."), scale: 3)
 
 Tells SwiftUI to treat it like a @3x image.

 **Fix 2 — Custom frame doesn't work directly:**
 - `.frame()` alone has no effect.
 - Adding `.resizable()` directly won't even compile — modifiers apply to the *AsyncImage wrapper*, not the loaded image itself.

 **Fix 3 — Two-closure form (image + placeholder):**
 
 AsyncImage(url: URL(string: "...")) { image in
     image
         .resizable()
         .scaledToFit()
 } placeholder: {
     Color.red   // or ProgressView()
 }
 .frame(width: 200, height: 200)
 
 - First closure customizes the loaded image (can make it resizable/scaled).
 - Second closure customizes the placeholder shown during loading.
 - Both resizable images and placeholders like `Color.red`/`ProgressView()` fill available space, so `.frame()` works here.

 **Fix 4 — Full phase control (handles success/error/loading):**
 
 AsyncImage(url: URL(string: "...")) { phase in
     if let image = phase.image {
         image.resizable().scaledToFit()
     } else if phase.error != nil {
         Text("There was an error loading the image.")
     } else {
         ProgressView()
     }
 }
 .frame(width: 200, height: 200)
 
 Useful for showing distinct UI on load failure (bad URL, offline, etc.) vs. loading vs. success.
 
*/

// ** VALIDATING AND DISABLING FORMS **

/*
 **Purpose:** Prevent form submission until input is valid, using the `.disabled()` modifier.

 **How `disabled()` works:**
 - Takes a Boolean condition.
 - When `true`, the attached view stops responding to user input (buttons can't be tapped, sliders can't be dragged, etc.).
 - Accepts any expression: simple properties, computed properties, method calls.

 **Basic example:**
 
 struct ContentView: View {
     @State private var username = ""
     @State private var email = ""

     var body: some View {
         Form {
             Section {
                 TextField("Username", text: $username)
                 TextField("Email", text: $email)
             }

             Section {
                 Button("Create account") {
                     print("Creating account…")
                 }
             }
         }
     }
 }
 

 **Disabling the button until fields are filled:**
 
 Section {
     Button("Create account") {
         print("Creating account…")
     }
 }
 .disabled(username.isEmpty || email.isEmpty)
 

 **Cleaner approach — computed property:**
 
 var disableForm: Bool {
     username.count < 5 || email.count < 5
 }
 
 
 .disabled(disableForm)
 
 Keeps validation logic organized and reusable, especially for more complex conditions.

 **UI behavior:** A disabled button appears grayed out; it automatically turns active (e.g., blue) once the condition becomes `false`.
*/
