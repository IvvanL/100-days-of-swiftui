// ** DAY 55 - BOOKWORM - PROJECT 11 - Part 3 **

// ** SHOWING BOOK DETAILS **

/*
 **Goal:** When a user taps a book in `ContentView`, show a detail screen with the genre artwork, author, review, and a read-only rating. It reuses `RatingView`.

 **Setup**
 - Add the genre artwork (from Unsplash, in the project's files folder) to the asset catalog. Image names must match the genre strings.
 - Create a new SwiftUI view called `DetailView`, import `SwiftData`, and give it one property: `let book: Book`.

 **Fixing the preview (the tricky part)**
 - Adding the `book` property breaks the default preview, because creating a SwiftData object requires a model context.
 - The chain is: **ModelConfiguration → ModelContainer → sample Book → DetailView**.
 - Use `ModelConfiguration(isStoredInMemoryOnly: true)` so nothing is saved permanently.
 - Create the container with `ModelContainer(for: Book.self, configurations: config)`. The parameter is plural: **`configurations`**.
 - Build an example `Book`, then pass it to `DetailView` with `.modelContainer(container)`.
 - The `Book` never references the container directly, but a container must exist or creating a model object can crash.
 - Wrap it in `do/catch`, returning a `Text` with the error on failure.
 
 ** code **
 
 #Preview {
     do {
         // 1. Settings: keep everything in memory, nothing saved to disk
         let config = ModelConfiguration(isStoredInMemoryOnly: true)

         // 2. Build the storage system using those settings.
         //    "for: Book.self" means "this container knows how to store Books"
         let container = try ModelContainer(for: Book.self, configurations: config)

         // 3. Make a fake book to show in the preview
         let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This is a test book", rating: 4)

         // 4. Show the view, and attach the container to it
         return DetailView(book: example)
             .modelContainer(container)
     } catch {
         // 5. If step 2 failed, show the error text in the preview instead
         return Text("Failed to create preview: \(error.localizedDescription)")
     }
 
 In practice, you'll copy this block into any view that takes a model and change three things: the model type, the example data, and the view being shown.

 **Designing the view**
 - Wrap everything in a **`ScrollView`** so long reviews and larger font sizes always fit.
 - Put the genre image and a genre label in a **`ZStack(alignment: .bottomTrailing)`**.
   - The image uses `.resizable()` and `.scaledToFit()`.
   - The label is uppercase, bold, white on a semi-transparent black capsule, with padding and a small offset.
 - Below the ZStack, add:
   - the author (`.title` font, `.secondary` style)
   - the review text (with padding)
   - a `RatingView` with `.constant(book.rating)`, which makes it read-only
 - `.font(.largeTitle)` scales the rating stars up because they're SF Symbols.
 - Navigation modifiers: `.navigationTitle(book.title)`, `.navigationBarTitleDisplayMode(.inline)`, and `.scrollBounceBehavior(.basedOnSize)`.

 **Wiring it up in ContentView**
 - Add `.navigationDestination(for: Book.self) { book in DetailView(book: book) }` to the `List`.
 - Run the app and tap a book to see the detail view.

 **Key takeaways**
 - Previews with SwiftData need an **in-memory container**.
 - `.constant()` bindings turn an editable control into a read-only display.
 - SF Symbols scale with `.font()`.
 - `ScrollView` protects the layout against varying content and device sizes.

*/

// ** SORTING SWIFTDATA QUERIES USING SORTDESCRIPTOR **

/*
 # Sorting SwiftData Queries with SortDescriptor

 **Goal:** Control the order of results from `@Query` so users get a predictable experience. Possible sort fields in this project: title, author, or rating.

 **Simple sorting (one field)**
 - Alphabetical by title:
   ```swift
   @Query(sort: \Book.title) var books: [Book]
   ```
 - By rating, highest first, using `order: .reverse`:
   ```swift
   @Query(sort: \Book.rating, order: .reverse) var books: [Book]
   ```
 - Ascending is the default (A to Z for text, low to high for numbers).

 **Advanced sorting with `SortDescriptor`**
 - Takes a property to sort on, plus an optional `order:`.
 - Passed to `@Query` as an **array**:
   ```swift
   @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
   ```
 - Reverse order:
   ```swift
   @Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) var books: [Book]
   ```

 **Multiple sort fields (tiebreakers)**
 - Descriptors are applied **in the order you list them**. The second is only used when the first is tied.
 - Example: two different books titled "Forever" (one by Pete Hamill, one by Judy Blume). Sort by title, then by author:
   ```swift
   @Query(sort: [
       SortDescriptor(\Book.title),
       SortDescriptor(\Book.author)
   ]) var books: [Book]
   ```
 - A common pattern is "sort by rating, then by title."

 **Performance**
 - Extra sort fields have little to no performance impact unless you have lots of data with similar values.
 - Most book titles are unique, so a second sort field is mostly irrelevant for speed here. It still adds predictability.

 **Key takeaways**
 - Always choose a sort order so results don't appear in an arbitrary order.
 - Use the simple `sort:` form for one field, and `SortDescriptor` when you want more than one.
 - Add a backup sort field for predictability.
*/

// ** DELETING FROM A SWIFTDATA QUERY **

/*
 **Goal:** Enable swipe to delete and an Edit/Done button in the `ContentView` list.

 **How it works**
 - It's similar to deleting from a regular array, and uses the `onDelete(perform:)` modifier.
 - Instead of removing an item from an array, you find the object in your `@Query` results and call `delete()` on the **model context**.
 - SwiftData's **autosave** then applies the changes permanently. You don't need to save manually.

 **Step 1: Add a delete method to `ContentView`**
 ```swift
 func deleteBooks(at offsets: IndexSet) {
     for offset in offsets {
         // find this book in our query
         let book = books[offset]

         // delete it from the context
         modelContext.delete(book)
     }
 }
 ```
 - `offsets` is an `IndexSet` of the positions the user swiped or selected.
 - `books[offset]` looks up the actual `Book` in the query results.
 - `modelContext.delete(book)` removes it.

 **Step 2: Attach it to the `ForEach`**
 
 .onDelete(perform: deleteBooks)
 
 - It must go on the **`ForEach`, not the `List`**.
 - This gives you swipe to delete.

 **Step 3: Add an Edit/Done button**
 - Inside the existing `toolbar()` modifier, add another `ToolbarItem`:
 
 ToolbarItem(placement: .topBarLeading) {
     EditButton()
 }
 
 - `EditButton()` toggles between "Edit" and "Done" and shows delete controls next to each row.

 **Result:** You can add and delete books, using either swipe to delete or the Edit button.

 **Key takeaways**
 - To delete a SwiftData object, call `modelContext.delete(object)`.
 - `onDelete` goes on the `ForEach`, not the `List`.
 - Autosave handles persistence after deletion.
 - `EditButton()` adds a dedicated edit mode with almost no extra code.
 
*/

// ** USING AN ALERT TO POP A NAVIGATIONLINK PROGRAMMATICALLY **

/*
 **Goal:** Add a delete button to `DetailView` that shows a confirmation alert, deletes the book, then automatically goes back to the previous screen.

 **Background**
 - Inside a `NavigationStack`, iOS gives you a Back button and swipe-from-left-edge to go back.
 - Sometimes you need to go back **programmatically**, when your code decides rather than when the user swipes.
 - Here, the book being shown no longer exists after deletion, so staying on the screen makes no sense. We **pop** the view off the navigation stack.

 **Step 1: Add three properties to `DetailView`**
 
 @Environment(\.modelContext) var modelContext
 @Environment(\.dismiss) var dismiss
 @State private var showingDeleteAlert = false
 
 - `modelContext` lets us delete the book.
 - `dismiss` lets us pop the view off the stack.
 - `showingDeleteAlert` controls whether the alert is visible.

 **Step 2: Write the delete method**
 
 func deleteBook() {
     modelContext.delete(book)
     dismiss()
 }
 
 - `dismiss()` works the same whether the view was presented with a sheet or a `NavigationLink`.

 **Step 3: Add a confirmation alert to the `ScrollView`**
 
 .alert("Delete book", isPresented: $showingDeleteAlert) {
     Button("Delete", role: .destructive, action: deleteBook)
     Button("Cancel", role: .cancel) { }
 } message: {
     Text("Are you sure?")
 }
 
 - The **button roles** (`.destructive` and `.cancel`) make the buttons look correct automatically.
 - The empty `{ }` on Cancel means "do nothing but close the alert."

 **Step 4: Add a toolbar button to start the process**
 
 .toolbar {
     Button("Delete this book", systemImage: "trash") {
         showingDeleteAlert = true
     }
 }
 
 - The button only flips `showingDeleteAlert` to `true`. The alert is already watching that value and appears.

 **Alert label guidance (Apple's advice)**
 - Use "OK" for a simple "I understand" acceptance.
 - When the user is making a choice, avoid "Yes" and "No." Use verbs like "Delete," "Ignore," "Reply," or "Confirm."

 **The flow**
 1. The user taps the trash button, so `showingDeleteAlert = true`.
 2. The alert appears with **Delete** and **Cancel**.
 3. On Delete, `deleteBook()` runs: the book is removed from the model context, then `dismiss()` pops the view.
 4. The list in `ContentView` updates automatically.

 **Key takeaways**
 - `@Environment(\.dismiss)` is the way to go back programmatically, and it works for both sheets and navigation pushes.
 - Pair a `@State` Boolean with an `.alert()` modifier, and the button just toggles the Boolean.
 - Use button roles (`.destructive`, `.cancel`) for correct styling.
 - Deleting from the model context is enough, because autosave handles persistence.
 - Users can now delete a book in two ways: from the list (swipe or Edit button) or from inside `DetailView`.
*/
