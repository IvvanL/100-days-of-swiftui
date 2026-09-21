#Day 55 - Bookworm - Project 11 part 3

## Showing Book Details
- Built `DetailView` to show a book's genre art, author, review, and rating
  - Takes one property: `let book: Book`
  - Genre images go in the asset catalog, named to match the genre strings
- SwiftData previews need an in-memory container
  - Chain: `ModelConfiguration` → `ModelContainer` → sample `Book` → `DetailView`
  - `isStoredInMemoryOnly: true` keeps preview data temporary
  - The parameter name is `configurations` (plural)
  - Wrap it in `do/catch` so errors show in the preview
  - Only needed for views that use SwiftData models, not plain-value views like `RatingView`
- Layout
  - `ScrollView` handles long reviews and large fonts
  - `ZStack(alignment: .bottomTrailing)` overlays the genre label on the image
  - `RatingView(rating: .constant(book.rating))` makes the rating read-only
  - `.font(.largeTitle)` scales SF Symbols
- Navigation
  - `.navigationDestination(for: Book.self)` in `ContentView` opens `DetailView`

## Sorting SwiftData Queries
- `@Query(sort:)` controls the order of results
  - One field: `@Query(sort: \Book.title)`
  - Reverse order: `order: .reverse`
- `SortDescriptor` handles multiple fields
  - Passed as an array
  - Applied in the order listed
  - Later descriptors only break ties
- Always pick a sort order and add a backup field for predictability
- Extra sort fields barely affect performance

## Deleting from a Query
- Write `deleteBooks(at:)`
  - Look up each book with `books[offset]`
  - Delete it with `modelContext.delete(book)`
- Attach `.onDelete(perform:)` to the `ForEach`, not the `List`
- Add `EditButton()` in a `ToolbarItem` for an Edit/Done mode
- Autosave persists the change, so no manual save is needed

## Alert and Programmatic Dismiss
- Added a delete button inside `DetailView`
  - `@Environment(\.modelContext)` to delete
  - `@Environment(\.dismiss)` to pop the view
  - `@State private var showingDeleteAlert` to control the alert
- `deleteBook()` deletes the book, then calls `dismiss()`
- `.alert()` watches the Bool
  - `Button("Delete", role: .destructive)`
  - `Button("Cancel", role: .cancel)`
- The toolbar button only sets the Bool to `true`
- `dismiss()` works for both sheets and navigation pushes
- Alert wording: use verbs like "Delete" or "Confirm" instead of "Yes/No"

## Key Takeaways
- SwiftData previews need an in-memory container
- `.constant()` makes a binding read-only
- Delete with `modelContext.delete()`, and autosave does the rest
- `@Environment(\.dismiss)` goes back programmatically
- A `@State` Bool plus `.alert()` is the standard confirmation pattern
