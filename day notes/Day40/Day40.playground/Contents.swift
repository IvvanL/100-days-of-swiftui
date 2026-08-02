// ** DAY 34 PROJECT 8, Part 2 **

// ** LOADING A SPECIFIC KIND OF CODABLE DATA **

/*
 
 Goal: Load JSON files (astronauts.json, missions.json) into Swift structs cleanly and reusably.
 
 1. Define the model
 
 struct Astronaut: Codable, Identifiable {
     let id: String
     let name: String
     let description: String
 }
 
 - Codable → lets it be created directly from JSON
 - Identifiable → needed to use in ForEach; the id field satisfies this
 
 2. Create a reusable Bundle extension
 
 - Instead of writing loading code inside each view, put it in one place: Bundle-Decodable.swift.
 
 extension Bundle {
     func decode(_ file: String) -> [String: Astronaut] {
         guard let url = self.url(forResource: file, withExtension: nil) else {
             fatalError("Failed to locate \(file) in bundle.")
         }

         guard let data = try? Data(contentsOf: url) else {
             fatalError("Failed to load \(file) from bundle.")
         }

         let decoder = JSONDecoder()

         guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
             fatalError("Failed to decode \(file) from bundle.")
         }

         return loaded
     }
 }
 
 Key points:
 
 - Data(contentsOf:) works like String(contentsOf:) but returns raw Data (what Codable needs) instead of a String.
 
 - Uses fatalError() on failure — acceptable here because these files ship inside the app bundle, so a failure means you made a mistake (e.g. forgot to add the JSON file), not something a user could ever trigger at runtime.
 
 3. Use it in a view
 
 let astronauts = Bundle.main.decode("astronauts.json")
 
 One line loads and decodes the whole file. Test it worked with:
 
 Text(String(astronauts.count)) // should show 32
 
 4. Improve error diagnostics (optional but recommended)
 
 Swap the generic try? for a do/catch that matches specific DecodingError cases, so failures explain exactly what went wrong:
 
 do {
     return try decoder.decode([String: Astronaut].self, from: data)
 } catch DecodingError.keyNotFound(let key, let context) {
     fatalError("Missing key '\(key.stringValue)' – \(context.debugDescription)")
 } catch DecodingError.typeMismatch(_, let context) {
     fatalError("Type mismatch – \(context.debugDescription)")
 } catch DecodingError.valueNotFound(let type, let context) {
     fatalError("Missing \(type) value – \(context.debugDescription)")
 } catch DecodingError.dataCorrupted(_) {
     fatalError("Invalid JSON.")
 } catch {
     fatalError("Decoding error: \(error.localizedDescription)")
 }
 
 
 Error case    Meaning
 - keyNotFound    JSON is missing a field the struct expects
 - typeMismatch    Value exists but wrong type (e.g. Int vs String)
 - valueNotFound    Key exists but value is null, property isn't optional
 - dataCorrupted    JSON file itself is malformed
 - plain catch    Fallback for any other error
 
 💡 Why an extension instead of a method?
 Keeps ContentView (and other views) small/focused, and makes the decode logic reusable across any JSON file/model in the app — not tied to one view.

*/


// ** USING GENERICS TO LOAD ANY KIND OF CODABLE DATA **

/*

 Problem: Now we have a second JSON type (missions.json) with more complex data. Copy-pasting the decode() method for each type is wasteful — generics let us write one method that works for any Codable type.
 
 1. Model the new data
 
 struct Mission: Codable, Identifiable {
     struct CrewRole: Codable {
         let name: String
         let role: String
     }

     let id: Int
     let launchDate: String?   // optional!
     let crew: [CrewRole]
     let description: String
 }
 
 Key points:
 
 - launchDate: String? is optional because Apollo 1 never launched. If a Codable property is optional, the decoder automatically skips it if missing from the JSON — no extra code needed.
 - CrewRole is nested inside Mission (a nested struct) since it only makes sense in that context. Access it elsewhere as Mission.CrewRole. Purely organizational — doesn't change behavior.
 
 2. Why generics?
 
 Instead of writing a separate decode() for astronauts, missions, etc., we write one method with a placeholder type, conventionally named T.
 
 func decode<T>(_ file: String) -> T {
     ...
     return try decoder.decode(T.self, from: data)
 }
 
 - <T> after the method name declares the placeholder.
 - T stands in for whatever type is requested — e.g. [String: Astronaut] or [Mission].
 
 ⚠️ T ≠ [T] — don't confuse "the type itself" with "an array of that type." If T = [String: Astronaut], then [T] would wrongly mean an array of dictionaries.
 
 3. Add a protocol constraint
 
 Plain <T> won't compile — Swift doesn't know T supports decoding. Fix with a constraint:
 
 func decode<T: Codable>(_ file: String) -> T {
 
 This tells Swift: "T can be any type, as long as it conforms to Codable."
 
 4. Specify the type at the call site
 
 - Since decode() no longer has one fixed return type, Swift needs a type annotation at the call site to infer T:
 
 let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
 let missions: [Mission] = Bundle.main.decode("missions.json")
 
 Same method, two completely different return types — that's the power of generics.
 
 5. Bonus fact: Codable = Encodable + Decodable
 
 Codable is just a type alias combining two protocols:
    + Encodable — can be converted to JSON/data
    + Decodable — can be converted from JSON/data
 
 You can use Codable for convenience, or Encodable/Decodable individually if you want to be explicit about which direction you need.
 
 💡 Big picture
 Generics let a single function adapt to many types safely (with protocol constraints acting as guardrails), avoiding duplicated code like decodeAstronauts(), decodeMissions(), etc.
 
*/

// ** FORMATTING OUR MISSION VIEW **

/*
 
 1. Add computed display properties to Mission
 
 Instead of repeating string interpolation everywhere, centralize formatting logic in the model:
 
 var displayName: String {
     "Apollo \(id)"
 }

 var image: String {
     "apollo\(id)"
 }
 
 If the naming scheme ever changes, you only update it in one place.
 
 2. Basic grid layout in ContentView

 let columns = [
     GridItem(.adaptive(minimum: 150))
 ]
 
 NavigationStack {
     ScrollView {
         LazyVGrid(columns: columns) {
             ForEach(missions) { mission in
                 NavigationLink {
                     Text("Detail view")
                 } label: {
                     VStack {
                         Image(mission.image)
                             .resizable()
                             .scaledToFit()
                             .frame(width: 100, height: 100)

                         VStack {
                             Text(mission.displayName)
                                 .font(.headline)
                             Text(mission.launchDate ?? "N/A")
                                 .font(.caption)
                         }
                         .frame(maxWidth: .infinity)
                     }
                 }
             }
         }
     }
     .navigationTitle("Moonshot")
 }
 
 - .adaptive(minimum: 150) → responsive columns that adjust to screen width.
 - resizable() + scaledToFit() + frame() → image fills a 100x100 box while keeping aspect ratio.
 - launchDate ?? "N/A" needed since launchDate is optional.
 
 3. Parse dates properly instead of using raw strings
 
 Raw JSON date like "1968-12-21" isn't user-friendly. Fix at the decoding level.
 
 In Bundle-Decodable.swift, after creating the decoder:
 
 let formatter = DateFormatter()
 formatter.dateFormat = "y-MM-dd"
 decoder.dateDecodingStrategy = .formatted(formatter)
 
 ⚠️ Date formats are case-sensitive: MM = month, mm = minutes.
 
 Change the model property from:
 
 let launchDate: String?
 
 to:
 
 let launchDate: Date?
 
 4. Fix the now-broken Text view with a computed property
 Since launchDate is now a Date?, you can't drop it straight into Text with ??. Add a computed property to Mission:
 
 var formattedLaunchDate: String {
     launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
 }
 
 Update ContentView:
 
 Text(mission.formattedLaunchDate)
 
 Bonus: .formatted() automatically displays the date in the user's own region format.
 
 5. Custom colors via ShapeStyle extension
 
 Two ways to add app colors: asset catalog (visual) or Swift extension (code — easier to track in git, preferred here).
 
 Create Color-Theme.swift (import SwiftUI, not Foundation):
 
 extension ShapeStyle where Self == Color {
     static var darkBackground: Color {
         Color(red: 0.1, green: 0.1, blue: 0.2)
     }

     static var lightBackground: Color {
         Color(red: 0.2, green: 0.2, blue: 0.3)
     }
 }
 
 - Extending ShapeStyle where Self == Color (not just Color directly) means these colors work anywhere SwiftUI expects a ShapeStyle — e.g. .background(), gradients, materials — not just plain color contexts.
 
 6. Apply the new styling
 
 Inner VStack (name + date):
 
 .padding(.vertical)
 .frame(maxWidth: .infinity)
 .background(.lightBackground)
 
 Outer VStack (whole NavigationLink label) — gives it a "card" look:
 
 .clipShape(.rect(cornerRadius: 10))
 .overlay(
     RoundedRectangle(cornerRadius: 10)
         .stroke(.lightBackground)
 )
 
 Image — add padding after the 100x100 frame:
 
 .padding()
 
 LazyVGrid (not ScrollView!) — add spacing from screen edges:
 
 .padding([.horizontal, .bottom])
 
 ⚠️ Padding the ScrollView instead would also pad the scrollbars — looks wrong.
 
 ScrollView — apply the dark background (after .navigationTitle()):
 
 .background(.darkBackground)
 
 7. Fix text contrast
 
 VStack {
     Text(mission.displayName)
         .font(.headline)
         .foregroundStyle(.white)
     Text(mission.formattedLaunchDate)
         .font(.caption)
         .foregroundStyle(.white.opacity(0.5))
 }
 
 Translucent white (opacity(0.5)) lets some background color show through for subtitle text.
 
 8. Force dark mode for consistent nav bar styling
 
 The "Moonshot" title belongs to NavigationStack and would otherwise be black in light mode (unreadable against dark background). Force dark mode:
 
 .preferredColorScheme(.dark)
 
 Add below .background(.darkBackground) on the ScrollView. This also darkens other system UI like the nav bar.
 💡 Big picture
    + Push formatting logic into model computed properties (displayName, image, formattedLaunchDate) to keep views clean and DRY.
    + Use DateFormatter + dateDecodingStrategy to decode custom date formats directly into real Date values.
    + Custom ShapeStyle-constrained Color extensions give reusable, git-trackable theme colors that work across all SwiftUI style-accepting modifiers.
 
 
 
 
*/
