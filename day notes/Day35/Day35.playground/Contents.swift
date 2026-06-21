// ** DAY 35 - MILESTONE PROJECT

// Key Points:

// Ranges with ForEach:
// - ForEach only acepts Range<Int> (using ..<), not ClosedRange<Int> (using...)
// - 0..<5 works with ForEach, 0...5 does not

// Strings in Swift:
// - strings are more complex than they appear - some emoji are made of multiple characters combined (ex. a thumbs up + skin modifier = one visible emoji)
// - because of this, .count cant just count characters blindly - it has to walk through the string carefully, which is slower but always correct

// Flat App Bundles
// - asset catalogs (images) get compiled and optimized at build time
// - all other loose files (text,JSON, etc) get flattened into a single resource directory regardless of how they're organized in Xcode
// - This means you cannot have two files with the same name anywhere in your project, even if they're in different folders - the build will fail

// CHALLENGE:

/*
 Your goal is to build an “edutainment” app for kids to help them practice multiplication tables – “what is 7 x 8?” and so on. Edutainment apps are educational at their core, but ideally have enough playfulness about them to make kids want to play.

 Breaking it down:

    + The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 2 to 12.
    + The player should be able to select how many questions they want to be asked: 5, 10, or 20.
    + You should randomly generate as many questions as they asked for, within the difficulty range they asked for.
 */
