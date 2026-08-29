#Day 49 - Cupcake Corner - Project 10, part 1 - completed

Multi-screen cupcake ordering app project. Covers forms, networking, and form validation.

**1. Sending/Receiving Codable Data with URLSession**
- Define `Codable` structs matching JSON structure (e.g. `Response` containing `[Result]`).
- Use `.task { }` (not `.onAppear`) to run async code when a view appears — supports `async`/`await` natively.
- `async` functions can pause on slow work (like networking) without freezing the app; call with `await`.
- Fetch data: `URLSession.shared.data(from: url)` returns `(Data, URLResponse)` — often discard response with `_`.
- Decode with `JSONDecoder().decode(Type.self, from: data)`.
- Write `try await`, not `await try`.
- This covers downloading (GET) only — sending Codable data (POST) comes later.

**2. Loading Remote Images with AsyncImage**
- `AsyncImage(url:)` downloads, caches, and displays remote images automatically.
- Doesn't know image size in advance → may render oversized/blurry. Fix with `scale:` parameter.
- Modifiers like `.resizable()`/`.frame()` don't apply directly to a plain `AsyncImage` — use the two-closure form (`{ image in ... } placeholder: { ... }`) to customize the loaded image and placeholder separately.
- For full control, use the phase-based closure to handle loading/success/error states distinctly.

**3. Validating & Disabling Forms**
- `.disabled(condition)` disables a view (button, section, etc.) when the condition is `true`.
- Common pattern: disable a "Submit"/"Create account" button until required fields are filled (e.g. `.disabled(username.isEmpty || email.isEmpty)`).
- Better practice: extract validation logic into a computed property (e.g. `disableForm`) for readability/reuse.
- Disabled buttons appear grayed out and automatically re-enable when the condition becomes `false`.
