// ** DAY 39 PROJECT 8, Part 1 **

// ** RESIZING IMAGES TO FIT THE AVAILABLE SPACE **

/*
 
 Resizing Images in SwiftUI

- Image views default to the pixel dimensions of their source content, ignoring .frame() unless you also add .resizable().
- Without .resizable(), .frame() only sets the view's box — the image content stays full-size and gets clipped or overflows. You can confirm this in Xcode's "Selectable" preview mode, or by adding .clipped() to see the mismatch.
- Adding .resizable() lets the image content scale to match the frame, but without an aspect mode it'll stretch/distort to fill that exact box.
- Use .scaledToFit() to keep the whole image visible within the frame (may leave empty space), or .scaledToFill() to fill the frame completely (may crop part of the image).
 
 Standard pattern:

 swift  Image(.example)
       .resizable()
       .scaledToFit() // or .scaledToFill()
       .frame(width: 300, height: 300)

- For responsive sizing (e.g. "80% of screen width") instead of fixed pixels, use .containerRelativeFrame(). You specify an axis (e.g. .horizontal) and a closure that returns a size relative to the parent container; SwiftUI infers the other dimension automatically based on aspect ratio.
- Asset-catalog images can be referenced via generated constants (Image(.example)) instead of strings (Image("Example")), which is safer/less error-prone.
 
 */

// ** HOW SCROLLVIEW LETS US WORK WITH SCROLLING DATA **

/*
 
 ScrollView in SwiftUI

 - Use ScrollView for scrolling arbitrary hand-built views (vs. List/Form which are for scrolling tables of data).
 - Can scroll horizontally, vertically, or both; scroll indicators can be toggled on/off.
 - Content size is auto-calculated from what's inside the ScrollView.
    Basic vertical scroll list:

    swift  ScrollView {
        VStack(spacing: 10) {
            ForEach(0..<100) {
                Text("Item \($0)")
                    .font(.title)
            }
        }
    }

- By default, only the content itself is tappable/draggable (not the full width). Fix by adding .frame(maxWidth: .infinity) to the VStack so the whole area becomes scrollable.
- Important gotcha: Regular VStack/HStack inside a ScrollView create all their child views immediately — not lazily as you scroll. This can hurt performance with expensive views.
- Fix: Use LazyVStack / LazyHStack instead — same syntax, but views are only created when they're about to appear on screen.

 swift  LazyVStack(spacing: 10) {
       ForEach(0..<100) {
           CustomText("Item \($0)")
               .font(.title)
       }
   }
   .frame(maxWidth: .infinity)

- Key layout difference: regular stacks size themselves to fit their content; lazy stacks always expand to fill all available space (so their size doesn't jump around as more views load in).
- For horizontal scrolling, pass .horizontal to ScrollView and pair it with HStack/LazyHStack:

 swift  ScrollView(.horizontal) {
       LazyHStack(spacing: 10) {
           ForEach(0..<100) {
               CustomText("Item \($0)")
                   .font(.title)
           }
       }
   }
 */


// ** PUSHING NEW VIEWS ONTO THE STACK USING NAVIGATIONLINK **

/*

 NavigationLink & NavigationStack in SwiftUI

 - NavigationStack shows a nav bar and enables pushing views onto a stack — the classic iOS pattern (e.g. Settings > Wi-Fi, or tapping a contact in Messages).
 - This "push" navigation is conceptually different from sheet():

        + NavigationLink → for drilling into related/detail content (e.g. selecting an item to see more about it).
        + sheet() → for unrelated content, like settings or a compose screen.


 - Plain text/views inside a NavigationStack are static — nothing happens on tap unless wrapped in NavigationLink.
 - Basic usage — give it a destination view and a label, it handles the rest:

    NavigationStack {
       NavigationLink("Tap Me") {
           Text("Detail View")
       }
       .navigationTitle("SwiftUI")
   }

 - Label becomes tappable/styled like a button.
 - Tapping slides in the destination from the right; the title animates into a back button (tappable, or swipe from left edge to go back).
 - Destination can be any view — a custom view or something as simple as Text.
 - For a custom label (not just plain text), use the two-trailing-closure form:

    NavigationLink {
       Text("Detail View")
   } label: {
       VStack {
           Text("This is the label")
           Image(systemName: "face.smiling")
       }
   }

- Most common pairing: NavigationLink inside a List:

    NavigationStack {
       List(0..<100) { row in
           NavigationLink("Row \(row)") {
               Text("Detail \(row)")
           }
       }
       .navigationTitle("SwiftUI")
   }

 - SwiftUI automatically adds gray disclosure indicators (chevrons) on rows that are NavigationLinks, signaling to users that tapping will push a new screen. Removing NavigationLink removes the indicator.
 
 */

// ** WORKING WITH HIERARCHICAL CODABLE DATA **

/*
 
 Decoding Hierarchical Codable Data in Swift

 - Codable handles flat JSON (single instances, arrays, dictionaries) automatically. For nested/hierarchical JSON, you need to create a separate struct for each level of nesting.
 - As long as your struct hierarchy matches the JSON structure, Codable decodes everything automatically — no manual parsing needed.
 
 - Example JSON (a user with a nested address object):

    {
       "name": "Taylor Swift",
       "address": {
           "street": "555, Taylor Swift Avenue",
           "city": "Nashville"
       }
   }

 - Matching Swift structs — one per nesting level:

   struct User: Codable {
       let name: String
       let address: Address
   }

   struct Address: Codable {
       let street: String
       let city: String
   }

 - Decoding steps:

    1. Convert the JSON string to Data: let data = Data(input.utf8)
    2. Create a JSONDecoder()
    3. Decode: try? decoder.decode(User.self, from: data)

    let data = Data(input.utf8)
   let decoder = JSONDecoder()
   if let user = try? decoder.decode(User.self, from: data) {
       print(user.address.street)
   }

 - There's no limit to how many nesting levels Codable can handle — it just requires your structs to accurately mirror the JSON's structure at every level.

*/


/*
 
real world example:

 Any time your app fetches data from an API, the server sends back JSON, and you need to turn that JSON into actual Swift objects you can use (show in a list, display in a view, store, etc). That conversion step is where Codable does the work.
 Typical flow looks like this:
 swiftfunc fetchWeather() async {
     let url = URL(string: "https://api.example.com/weather")!
     
     do {
         let (data, _) = try await URLSession.shared.data(from: url)
         let decoder = JSONDecoder()
         let weather = try decoder.decode(WeatherResponse.self, from: data)
         // now `weather` is a real Swift struct you can use
         print(weather.current.temperature)
     } catch {
         print("Failed to fetch or decode: \(error)")
     }
 }

 URLSession does the actual networking — hits the API, gets raw Data back (which is really just JSON as bytes).
 JSONDecoder takes that raw Data and, using your Codable structs as a blueprint, converts it into real Swift objects.
 From there you just use weather.current.temperature like any normal Swift property — no dictionary digging, no manual parsing.

 So your structs (WeatherResponse, CurrentWeather, Condition, etc.) act as a contract that describes exactly what shape you expect the API's JSON to be in. As long as it matches, decoding just works.
 This is genuinely one of the most common things you'll do in iOS development — pretty much every app that talks to a backend uses this pattern.
 
*/


// ** HOW TO LAY OUT VIEWS IN A SCROLLING GRID **

/*
 
 Grids in SwiftUI

 - Use LazyVGrid (vertical) or LazyHGrid (horizontal) to show data in a grid layout, not just rows like List.
 - "Lazy" = same as lazy stacks — views are only created when they're about to appear on screen, saving resources.
 - Two-step setup: define your rows/columns layout, then place the grid inside a ScrollView.

 Fixed-width columns:
 
 let layout = [
     GridItem(.fixed(80)),
     GridItem(.fixed(80)),
     GridItem(.fixed(80))
 ]

 ScrollView {
     LazyVGrid(columns: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }

 - Items auto-fill into columns, same way List rows auto-place.

 Adaptive columns (more flexible, adapts to screen size):
 
 let layout = [
     GridItem(.adaptive(minimum: 80)),
 ]

 - Fits as many columns as possible, each at least 80 points wide.
 - Can add a maximum too for tighter control:

 GridItem(.adaptive(minimum: 80, maximum: 120))

 - Adaptive layouts are generally preferred since they make the best use of available screen space across different devices.

 - Horizontal grids: nearly identical, just flip the axis — use ScrollView(.horizontal) and LazyHGrid(rows:) instead:
 
 ScrollView(.horizontal) {
     LazyHGrid(rows: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }
 
 
 
 
*/
