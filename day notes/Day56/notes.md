#Day 56 - Bookworm - Project 11 part 4 - CHALLENGE - COMPLETED

## 1. Prevent books from being saved with no title, author, or genre

**Problem:** `AddBookView` let you save a book with an empty title or author (or one made only of spaces), which broke the assumptions `DetailView` and `ContentView` make about every book having real data. The genre picker always starts with a valid selection, so genre wasn't actually at risk — it just needed its asset names double-checked.

**Fix:** Added a computed property, `hasValidInput`, that trims whitespace from `title` and `author` before checking whether either is empty, then disabled the Save button until both pass.

```swift
var hasValidInput: Bool {
    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedTitle.isEmpty == false && trimmedAuthor.isEmpty == false
}
```

```swift
Section {
    Button("Save") {
        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
        modelContext.insert(newBook)
        dismiss()
    }
}
.disabled(!hasValidInput)
```

Also confirmed every genre in the `genres` array ("Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller") has a matching image set in `Assets.xcassets`, so `Image(book.genre)` in `DetailView` always finds an image.

## 2. Highlight 1-star books in the list

**Problem:** All book titles in `ContentView` looked the same regardless of rating, making it hard to spot the ones you rated lowest.

**Fix:** Used a ternary inside `.foregroundStyle` on the title's `Text`, so 1-star books turn red while everything else keeps the default color.

```swift
Text(book.title)
    .font(.headline)
    .foregroundStyle(book.rating == 1 ? .red : .primary)
```

## 3. Record and display when each book was added

**Problem:** `Book` had no sense of *when* it was created.

**Fix:** Added a `date` property to `Book` that defaults to `Date.now` right at its declaration, so it's set automatically and doesn't need to be passed into `init`.

```swift
@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var date: Date = Date.now

    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
```

Displayed it in `DetailView` using SwiftUI's built-in date-formatting `Text` initializer:

```swift
Text(book.date, style: .date)
    .padding()
```

## What I practiced

- Computed properties vs. `@State`, and when to use each
- `trimmingCharacters(in:)` for validating text input
- `.disabled(_:)` and where in the view hierarchy a modifier actually applies
- Ternary expressions inside view modifiers
- Giving a `@Model` property a default value instead of an `init` parameter
- The `Text(_:style:)` initializer for formatting dates
