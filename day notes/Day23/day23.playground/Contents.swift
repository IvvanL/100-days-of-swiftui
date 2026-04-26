import Cocoa

/*
 
 ** DAY 23 PROJECT 3 - ViewsAndModifiers PART 1 **
 
 **VIEWS AND MODIFIERS INTRO**
 
 - project 3 will be our first technique project
 - looking at how they work in detail along with why they work that way
 - in this technique project we're going to take a close look at views and view modifiers
 + why does swiftUI use structs for its views?
 + why does it use some View so much?
 + how do modifiers really work?
 
 ** WHY DOES SWIFTUI USE STRUCTS FOR VIEWS **
 
 - 2 main reasons: performance and state management
 
 Performance:
 + structs are simpler and faster than classes
 + in UIkit, every view inherited from UIview which had 200+ properties and methods passed down whether needed or not
 + SwiftUI structs contain only what you can see - no hidden inherited baggage
 + creating thousands of SwiftUI views is essentially free on modern Iphones
 
 State Management(the bigger reason)
 + classes can change their values freely - swiftUI wouldnt know when to update the UI
 + structs force immutability, pushing you toward a cleaner functional design
 + views become simple things that convert data into UI rather than complex objects that grow out of control
 + @state exists - its the controlled way to allow change when needed
 
 Key Takeaway
 + SwiftUI views are intentionally "dumb and inert. They dont mutate over time - they just take data and render it. This makes them predictable, fast, and easy to reason about
 Rule
 + Always use structs for views, never classes - your code either wont compile or will crash at runtime if you try
 
 
 ** WHAT IS BEHIND THE MAIN SWIFTUI VIEW **
 
 - there is nothing behind SwiftUI view
 
 What actually exists behind it:
 - technically theres a UIHostingController - the bridge between UIKit and SwiftUI
 - but you should never try to modify it - it breaks cross-platform support and may stop working in future IOS versions
 - treat it as if nothing else is there
 
 Solution:
 - instead of trying to color whats behind the view, make your view fill the screen using frame():
 
 .frame(maxWidth: .infinity, maxHeight: .infinity)
 
 maxWidth/maxHeight VS width/height
 + width/height - forces an exact size
 + maxWidth/maxHeight - says "you CAN take up this much space" but still lets other views get their share
 
 ** WHY MODIFIER ORDER MATTERS **
 The core concept:
 + Every modifier creates a brand new view with that change applied — it doesn't modify the existing view in place. Modifiers stack up like layers, each wrapping the previous one
 
 practical example:
 Button("Hello")
 .background(.red)  // colors just the button
 .frame(200x200)    // expands frame, but background already applied
 
 VS
 
 Button("Hello")
     .frame(200x200)    // expands first
     .background(.red)  // now colors the full 200x200 area

- Key Takeaway: Modifier order = rendering order. Always think about what exists at the time each modifier is applied
