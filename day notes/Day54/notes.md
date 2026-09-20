#Day 54 - Bookworm - Project 11 part 2

**Topics:** Creating books with SwiftData, a custom star rating component, and building a list with `@Query`.

## 1. Creating Books with SwiftData

**Goal:** Build a SwiftData model for books, a form to add them, and a way to show and dismiss that form.

**The model (`Book.swift`)**
- `import SwiftData`, then mark a class with `@Model`.
- Properties: `title`, `author`, `genre`, `review` (Strings) and `rating` (Int).
- It needs an initializer. Typing `in` inside the class makes Xcode autocomplete it.

**Model container (`BookwormApp.swift`)**
- `import SwiftData`, then add `.modelContainer(for: Book.self)` to the `WindowGroup`.

**The form (`AddBookView`)**
- `@Environment(\.modelContext) var modelContext` gives access to the model context.
- `@Environment(\.dismiss) var dismiss` closes the view.
- `@State` properties: `title`, `author`, `rating` (default 3), `genre` (default "Fantasy"), `review`.
- `let genres = [...]` holds the picker options.
- The body is a `NavigationStack` containing a `Form` with a title/author/genre section, a "Write a review" section, and a Save button.

```swift
// Save button action
let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
modelContext.insert(newBook)
dismiss()
```

**Showing the form (`ContentView`)**
- Add `import SwiftData`, `@Environment(\.modelContext) var modelContext` (for deleting books later), `@Query var books: [Book]`, and `@State private var showingAddScreen = false`.
- The body is a `NavigationStack` with a temporary `Text("Count: \(books.count)")` to verify saving works.
- A `.topBarTrailing` toolbar button toggles `showingAddScreen`. The placement is explicit so a second button can be added later.
- `.sheet(isPresented: $showingAddScreen) { AddBookView() }` presents the form.

**Result:** Add a book, and when the sheet dismisses the count updates to 1.

## 2. Custom Star Rating Component

**Goal:** Build a reusable `RatingView` for picking a rating by tapping stars.

**Key idea:** Custom UI components are just views that expose a `@Binding` to read and write a value.

**Properties**
```swift
@Binding var rating: Int

var label = ""
var maximumRating = 5

var offImage: Image?
var onImage = Image(systemName: "star.fill")

var offColor = Color.gray
var onColor = Color.yellow
```
- If `offImage` is `nil`, `onImage` is used for both states.

**Preview fix:** The build fails at first because the preview has no binding. Use a **constant binding** (fixed value, can't change in the UI):
```swift
#Preview {
    RatingView(rating: .constant(4))
}
```

**Choosing the image**
```swift
func image(for number: Int) -> Image {
    if number > rating {
        offImage ?? onImage
    } else {
        onImage
    }
}
```

**Body**
```swift
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
```

**Using it in `AddBookView`:** Replace the second section with:
```swift
Section("Write a review") {
    TextEditor(text: $review)
    RatingView(rating: $rating)
}
```

**Common bug: it always selects 5 stars**
- **Cause:** Inside a `Form` or `List`, SwiftUI treats the whole row as tappable and triggers every button in it, in order (1 through 5).
- **Fix:** Add `.buttonStyle(.plain)` to the whole `HStack` so each button is treated individually.

## 3. Building a List with `@Query`

**Goal:** Replace the temporary count text with a `List` of saved books showing rating, title, and author.

**`EmojiRatingView`**
- It's a project-specific view that shows one of five emoji depending on the rating. It's a good example of view composition.
- The numbers below are placeholders (emoji can cause problems in e-readers), so swap in your own emoji.

```swift
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
```

**The list in `ContentView`**
```swift
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
```
- No `id` is needed in `ForEach` because all SwiftData models automatically conform to `Identifiable`.
- Keep the earlier modifiers (`navigationTitle()`, toolbar, sheet) in place.

**Not working yet:** Tapping a row does nothing until a `navigationDestination()` is added, which comes after the detail view is built.
