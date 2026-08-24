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
