# Day 40 - Moonshot Project 8, part 2 - complete

- learend to load a specific kind of Codable data
- Used generics to load any kind of codable data
- Formatted views

- Learned concepts:

- Error handling
    + try? hides errors; do/try/catch reveals them
    + Catch specific DecodingError cases for precise JSON debugging

- Generics
    + <T> = generic placeholder type
    + <T: Codable> = constrained to Codable types only
    + T ≠ [T]
    + Type annotation needed at call site for inference

- Codable models
    + Optional properties auto-skip missing JSON fields
    + Nested structs organize related types (Mission.CrewRole)
    + Codable = Encodable + Decodable

- Dates
    + dateDecodingStrategy = .formatted(formatter) for custom date parsing
    + Date format is case-sensitive (MM ≠ mm)
    + .formatted(date:time:) for clean, localized display

SwiftUI theming
    + Extend ShapeStyle where Self == Color for reusable custom colors
    + .preferredColorScheme(.dark) forces consistent dark mode
    + Pad LazyVGrid, not ScrollView
