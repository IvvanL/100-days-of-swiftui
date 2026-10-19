# Day 60 –   Milestone: Projects 10-12

# Advanced Codable in Swift (KEY POINTS)

## Three ways to handle JSON that doesn't match your Swift types

Prefer them in this order (1 = best, 3 = last resort):

1. **Automatic name conversion**: snake_case ↔ camelCase
2. **Custom property name mappings**: via a `CodingKeys` enum
3. **Fully custom Codable implementation**: for type changes or complex logic

---

## 1. Automatic snake_case conversion

Set a strategy on the decoder before decoding:

```swift
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
let user = try decoder.decode(User.self, from: data)
```

Converts `first_name` in JSON to `firstName` in Swift.

---

## 2. Custom CodingKeys

Use when JSON names are completely different (e.g. `"first"` vs `firstName`).

```swift
struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }

    var firstName: String
    var lastName: String
}
```

**Key points:**

- The enum name `CodingKeys` is special. Swift automatically uses it for encoding/decoding. Any other name (e.g. `ZZZCodingKeys`) is ignored.
- Case names = Swift property names; raw string values = JSON property names.
- If `CodingKeys` omits a property (with no default), the code won't compile because there's no way to initialize it.
- With this in place, you don't need `keyDecodingStrategy`.

---

## 3. Fully custom Codable implementation

Needed when types differ (e.g. JSON gives `"age": "13"` as a string but you want an `Int`), and for making **SwiftData models Codable**.

You must add:

- `init(from decoder: Decoder) throws`
- `func encode(to encoder: Encoder) throws`

```swift
struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
        case age
    }

    var firstName: String
    var lastName: String
    var age: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        let stringAge = try container.decode(String.self, forKey: .age)
        self.age = Int(stringAge) ?? 0  // default if conversion fails
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(String(self.age), forKey: .age)  // write back as string
    }
}
```

### The four lines that matter

- `decoder.container(keyedBy: CodingKeys.self)`: gets access to all the keys that can be read.
- `container.decode(String.self, forKey: .firstName)`: reads the JSON value for that key and assigns it to your Swift property. The `CodingKeys` renaming still applies, so `.firstName` actually looks up `"first"` in the JSON.
- `encoder.container(keyedBy: CodingKeys.self)`: creates the place to write values (inverse of the first).
- `container.encode(self.firstName, forKey: .firstName)`: writes the property out


# Day 60: FriendFace (Milestone Project)

A SwiftUI app that downloads JSON from the internet, decodes it with `Codable`, and displays it using `NavigationStack` and `List`.

**Data source:** https://www.hackingwithswift.com/samples/friendface.json

## Status

IN PROGRESS. Networking and the list screen are finished. The detail screen is started.

## Completed

### Data models
- `Friend`: `Identifiable`, `Codable` struct with `id` and `name`
- `User`: `Identifiable`, `Codable` struct with `id`, `isActive`, `name`, `age`, `company`, `email`, `address`, `about`, `registered`, `tags`, and `friends`
- Changed `id` from `Int` to `UUID` in both structs after inspecting the JSON

### Networking
- Created the `URL` safely with `guard let`
- Downloaded data using `URLSession.shared.data(from:)` with `try await`
- Decoded `[User]` using `JSONDecoder` with `dateDecodingStrategy = .iso8601`
- Stored the result in a `@State` array
- Wrapped the throwing code in `do`/`catch`
- Added a guard (`users.isEmpty`) so the download only runs when no users are loaded
- Triggered the download with the `.task` modifier

### List screen
- Wrapped the UI in a `NavigationStack`
- Displayed all 100 users in a `List`
- Each row shows the user's name and a capsule badge (green "Active" / red "Inactive") driven by `isActive`
- Added `.navigationTitle("FriendFace")`

### Detail view (started)
- Created `DetailView` with a `let user: User` property
- Built a sample `User` inside `#Preview` so the view can be developed without running the full app

## Still to do

### Required by the challenge
- [ ] Make each row tappable with `NavigationLink`, passing the selected `user` to `DetailView`
- [ ] Show more information in `DetailView`: age, company, email, address, about, registered date, and tags
- [ ] Show the names of the user's friends in `DetailView`

### Polish (optional)
- [ ] Group the detail screen into `Section`s inside a `List` or `Form`
- [ ] Format the `registered` date for display
- [ ] Add `.navigationTitle(user.name)` to the detail screen
- [ ] Show something in the UI when the download fails, instead of only printing the error
- [ ] Try the value-based navigation approach (`NavigationLink(value:)` + `.navigationDestination(for:)`), which requires `User` and `Friend` to be `Hashable`

## What I learned
- Designing `Codable` structs to match JSON, including checking the actual type of each key
- Using `async`/`await` and `URLSession` to fetch data
- Using `guard let` and `guard` to exit early
- Using `@State` to hold fetched data so the view updates
- Using `.task` to run async code when a view appears
- Building a custom badge with `.background(_, in: .capsule)`
- Passing data into a child view and previewing it with sample data
