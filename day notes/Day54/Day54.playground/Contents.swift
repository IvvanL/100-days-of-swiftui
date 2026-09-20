// ** DAY 54 - BOOKWORM - PROJECT 11 - PART 2

// ** CREATING BOOKS WITH SWIFTDATA **

/*
 **Goal:** Build a SwiftData model for books, a form to add them, and a way to show and dismiss that form.

 ## 1. The model (`Book.swift`)
 - `import SwiftData`, then mark a class with `@Model`.
 - Properties: `title`, `author`, `genre`, `review` (Strings) and `rating` (Int).
 - It needs an initializer. Typing `in` inside the class makes Xcode autocomplete it.

 ## 2. Model container (`BookwormApp.swift`)
 - `import SwiftData`, then add `.modelContainer(for: Book.self)` to the `WindowGroup`.

 ## 3. The form (`AddBookView`)
 **Properties:**
 - `@Environment(\.modelContext) var modelContext` gives access to the model context.
 - `@Environment(\.dismiss) var dismiss` closes the view.
 - `@State` properties: `title`, `author`, `rating` (default 3), `genre` (default "Fantasy"), `review`.
 - `let genres = [...]` is the array of genre options for the picker.

 **Body:** a `NavigationStack` containing a `Form` with three sections:
 - `TextField`s for title and author, plus a genre `Picker` built with `ForEach`.
 - A "Write a review" section with a `TextEditor` and a rating `Picker` (`ForEach(0..<6)`).
 - A Save button.

 **Save action:**
 
 let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
 modelContext.insert(newBook)
 dismiss()
 

 ## 4. Showing the form (`ContentView`)
 - `import SwiftData`, then add:
   - `@Environment(\.modelContext) var modelContext`, to be used later for deleting books.
   - `@Query var books: [Book]`, which reads all saved books.
   - `@State private var showingAddScreen = false`, which tracks whether the sheet is showing.
 - The body is a `NavigationStack` with:
   - `Text("Count: \(books.count)")` as a temporary check that saving works.
   - `.navigationTitle("Bookworm")`.
   - A toolbar button (`.topBarTrailing`) that toggles `showingAddScreen`. The placement is explicit so a second button can be added later.
   - `.sheet(isPresented: $showingAddScreen) { AddBookView() }`.

 ## Result
 Run the app, add a book, and when the sheet dismisses the count label updates to 1.
*/

// ** ADDING A CUSTOM STAR RATING  COMPONENT **

/*
 **Goal:** Build a reusable `RatingView` that lets the user pick a rating by tapping stars, then use it in `AddBookView`.

 ## Key idea
 Custom UI components in SwiftUI are just views that expose a `@Binding` to read and write a value.

 ## 1. Properties (`RatingView`)
 
 @Binding var rating: Int

 var label = ""
 var maximumRating = 5

 var offImage: Image?
 var onImage = Image(systemName: "star.fill")

 var offColor = Color.gray
 var onColor = Color.yellow
 
 - `label` is optional text shown before the stars.
 - `maximumRating` sets how many stars appear.
 - `offImage` defaults to `nil`. If it's `nil`, the `onImage` is used for both states.
 - `onColor` and `offColor` are the colors for highlighted and unhighlighted stars.
 - The `@Binding` reports the user's selection back to whatever view uses the component.

 ## 2. Fixing the preview
 The build fails at first because the preview doesn't supply a binding. Use a **constant binding**, which has a fixed value and can't change in the UI, so it's ideal for previews:
 
 #Preview {
     RatingView(rating: .constant(4))
 }

 ## 3. Choosing which image to show
 
 func image(for number: Int) -> Image {
     if number > rating {
         offImage ?? onImage
     } else {
         onImage
     }
 }
 
 - If the number is greater than the current rating, return `offImage`, or `onImage` if `offImage` is `nil`.
 - Otherwise, return `onImage`.

 ## 4. The body
 
 HStack {
     if label.isEmpty == false {
         Text(label)
     }

     ForEach(1..<maximumRating + 1, id: \.self) { number in
         Button {
             rating = number
         } label: {
             image(for: number)
                 .foregroundStyle(number > rating ? offColor : onColor)
         }
     }
 }
 
 - It shows the label if there is one.
 - `ForEach` loops from 1 to `maximumRating`.
 - Each star is a `Button` that sets `rating = number`.
 - The foreground color depends on whether the star is above or below the current rating.

 ## 5. Using it in `AddBookView`
 Replace the second section with:
 
 Section("Write a review") {
     TextEditor(text: $review)
     RatingView(rating: $rating)
 }
 

 ## 6. The common bug: always selects 5 stars
 - **Cause:** Inside a `Form` or `List`, SwiftUI assumes the whole row is tappable and triggers every button in it. With multiple buttons, they fire in order (1, 2, 3, 4, 5), so the rating always ends at 5.
 - **Fix:** Add this modifier to the whole `HStack`:
 
 .buttonStyle(.plain)

 This makes SwiftUI treat each button individually.

 ## Result
 Star ratings work as expected, and they're more natural than a picker in a detail view.
*/

// ** BUILDING A LIST WITH QUERY **

/*
 **Goal:** Replace the temporary count text in `ContentView` with a `List` of all saved books, showing each book's rating, title, and author.

 ## Starting point
 `ContentView` already has `@Query var books: [Book]` and displays `Text("Count: \(books.count)")`. That text view gets replaced.

 ## 1. `EmojiRatingView`
 A small project-specific view that shows one of five emoji depending on the rating. Unlike `RatingView`, it isn't meant for reuse in other projects. It's also a good example of how easy view composition is in SwiftUI.

 struct EmojiRatingView: View {
     let rating: Int

     var body: some View {
         switch rating {
         case 1:
             Text("1")
         case 2:
             Text("2")
         case 3:
             Text("3")
         case 4:
             Text("4")
         default:
             Text("5")
         }
     }
 }

 #Preview {
     EmojiRatingView(rating: 3)
 }
 
 - The numbers are placeholders. Paul used them because emoji can cause problems in e-readers. Swap in whatever emoji you like for each rating.
 - `default` covers 5 (and anything else).

 ## 2. The list in `ContentView`
 
 List {
     ForEach(books) { book in
         NavigationLink(value: book) {
             HStack {
                 EmojiRatingView(rating: book.rating)
                     .font(.largeTitle)

                 VStack(alignment: .leading) {
                     Text(book.title)
                         .font(.headline)
                     Text(book.author)
                         .foregroundStyle(.secondary)
                 }
             }
         }
     }
 }
 
 - **No `id` needed in `ForEach`:** all SwiftData models automatically conform to `Identifiable`.
 - Each row is a `NavigationLink(value: book)` containing an `HStack` with the emoji rating and a `VStack` of title and author.
 - Keep the earlier modifiers (`navigationTitle()`, toolbar, sheet) in place.

 ## Not working yet
 Navigation won't work until a `navigationDestination()` is added. That comes after the detail view is built in the next step.
*/
