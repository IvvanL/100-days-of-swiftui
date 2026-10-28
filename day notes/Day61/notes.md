# Day 61 - FriendFace Part 2 (SwiftData) Challenge

Extends the Day 60 FriendFace app so it works offline. The JSON is downloaded once, saved with SwiftData, and the views read from the saved copy.

**Data source:** https://www.hackingwithswift.com/samples/friendface.json

## Status

Complete. All requirements of the challenge are done.

## Challenge requirements

- [x] Store the downloaded data with SwiftData
- [x] Display the views from the SwiftData models
- [x] Only fetch the data once
- [x] Works offline after the first launch

## What was built

### Models
- `Friend` and `User` converted from structs to `@Model` classes
- Both conform to `Codable` with a custom implementation:
  - `CodingKeys` lists the properties that are encoded and decoded
  - `init(from:)` builds the object from JSON
  - `encode(to:)` writes the object back out
- Each class has a plain `init` as well, since classes don't get a free memberwise initializer
- `let` properties changed to `var`, which SwiftData needs
- `User` holds an array of `Friend`, and SwiftData saves the friends along with their user

### SwiftData setup
- Added `.modelContainer(for: User.self)` in `Day61App.swift` to create the database
- Replaced `@State private var users: [User] = []` with `@Query private var users: [User]`
- Added `@Environment(\.modelContext)` to get access to the database

### Fetch once and save
- `loadData()` still downloads and decodes `[User]` with the ISO-8601 date strategy
- A loop inserts each decoded user with `modelContext.insert`
- The existing `guard users.isEmpty` now checks the saved data, so the download is skipped on later launches

### Testing "fetch once" and offline
- First launch: list fills with 100 users
- Second launch: list appears straight away and no download runs
- With no connection: the list still shows from the saved data

## What I learned
- Why a `@Model` needs a class, and why a class needs its own `init`
- Writing custom `Codable` conformance: `CodingKeys`, `init(from:)`, and `encode(to:)`
- Checking that `CodingKeys`, decoding, and encoding all list the same properties
- Creating a model container and reading saved data with `@Query`
- Saving objects with `modelContext.insert`
- How a clean split between models, networking, and views made the change small
