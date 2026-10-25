# Day 60: FriendFace (Milestone Project)

A SwiftUI app that downloads JSON from the internet, decodes it with `Codable`, and displays it using `NavigationStack` and `List`.

**Data source:** https://www.hackingwithswift.com/samples/friendface.json

## Status

Complete. All required parts of the challenge are done.

## Screenshots

### Home (user list)
![Home screen showing the list of users](screenshots/Home.png)

### Detail view
![Detail view for a user](screenshots/DetailView.png)

### Detail view (continued)
![Detail view scrolled to tags and friends](screenshots/DetailView1.png)

Image files: [Home.png](Day60/Day60/Home.png) | [DetailView.png](Day60/Day60/DetailView.png) | [DetailView1.png](Day60/Day60/DetailView1.png)

## Challenge requirements

- [x] Fetch the data and parse it into `User` and `Friend` structs
- [x] Display a list of users with their name and whether they are active
- [x] Detail view shown when a user is tapped, including the names of their friends
- [x] Check that the `User` array is empty before starting the download

## What was built

### Data models
- `Friend`: `Identifiable`, `Codable` struct with `id` and `name`
- `User`: `Identifiable`, `Codable` struct with `id`, `isActive`, `name`, `age`, `company`, `email`, `address`, `about`, `registered`, `tags`, and `friends`
- `id` is a `UUID` in both structs (found by inspecting the JSON)

### Networking
- Safely created the `URL` with `guard let`
- Downloaded with `URLSession.shared.data(from:)` using `try await`
- Decoded `[User]` with `JSONDecoder` and `dateDecodingStrategy = .iso8601`
- Stored the result in a `@State` array
- Used `do`/`catch` for errors
- Guarded with `users.isEmpty` so the download only runs once
- Triggered the download with the `.task` modifier

### List screen
- `NavigationStack` with a `List` of all 100 users
- Each row shows the name and a capsule badge (green "Active" / red "Inactive")
- Each row is a `NavigationLink` to the detail view

### Detail screen
- `DetailView` takes a `User` and shows it in a sectioned `List`
- **User Info:** company, age, email, address, registered date (formatted)
- **About:** the user's description
- **Tags:** one row per tag, using `ForEach` with `id: \.self`
- **Friends:** one row per friend name, using `ForEach` over `Identifiable` values
- Navigation title set to the user's name
- Preview built with a sample `User` so the view can be developed without running the app

## What I learned
- Designing `Codable` structs to match JSON, including checking the real type of each key
- `async`/`await` and `URLSession` for fetching data
- `guard let` and `guard` for early exits
- `@State` to hold fetched data so the view updates
- `.task` to run async code when a view appears
- `NavigationLink` with a destination and a label
- `LabeledContent`, `Section`, and `ForEach` for building a detail screen
- Passing data into a child view and previewing it with sample data
