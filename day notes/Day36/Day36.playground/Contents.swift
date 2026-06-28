// ** DAY 36 - iExpense - Project 7, part 1

// ** USING @STATE WITH CLASSES **

// @State with classes VS structs
// + @State works perfectly with structs - when any property changes, Swift creates a whole new struct, which @State detects and triggers a UI refresh
// + @State does not work with classes by default - when a class property changes, the class instance itself doesnt change, so @State doesnt notice anything andf the UI wont update
// + to fix this, add @Observable before the class definition. this tells SwiftUI to watch the individual properties inside the class for changes instead.
// + They key practical difference: use classes when you need to SHARE DATA BETWEEN MULTIPLE VIEWS (they all point to the same instance). Use structs when date is LOCAL TO ONE VIEW.
