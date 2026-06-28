# 🦁 Edutainment — Day 35 Milestone project

A fun, animal-themed multiplication practice app for kids built as part of Paul Hudson's [100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui) challenge.

---

## 📱 Screenshots

| Settings | Game | Correct Answer | Game Over |
|----------|------|----------------|-----------|
| ![Settings](screenshots/state1.png) | ![Game](screenshots/state2.png) | ![Correct](screenshots/correct.png) | ![Game Over](screenshots/gameover.png) |

---

## 🎯 Project Goal

Build an edutainment app that helps kids practice multiplication tables with enough playfulness to keep them engaged.

**Requirements:**
- Player selects which multiplication table to practice (2–12)
- Player chooses how many questions to answer (5, 10, or 20)
- App randomly generates questions within the selected difficulty range

---

## ✨ Features

- 🐾 Random animal appears with each question from the Kenney Animal Pack
- ✅ Correct/Incorrect feedback popup that auto-dismisses with a fade animation
- 🟢 Green popup for correct answers, 🔴 red for incorrect
- 🏆 Live score tracking throughout the game
- 🎉 Animated Game Over screen with scattered animal decorations
- 🌈 Colorful gradient backgrounds throughout

---

## 🧠 What I Learned

### SwiftUI Fundamentals
- **`@State` variables** — managing app state and driving UI updates
- **`ZStack`, `VStack`, `HStack`** — composing layouts and layering views
- **`Form` + `Picker`** — building settings screens with native controls
- **`.pickerStyle(SegmentedPickerStyle())`** — segmented control for question count
- **`.overlay()`** — layering feedback popups on top of existing views
- **`ForEach`** — dynamically rendering lists of views from data
- **`if let` optional binding** — safely unwrapping optional values

### Data Modelling
- Creating custom **`struct` types** (`Question`, `DecorationAnimal`) to group related data
- Understanding why data should live in **structs** rather than loose state variables
- Using **`let` constants** for data that doesn't change (animals array)

### Animations & Timing
- **`DispatchQueue.main.asyncAfter`** — running code after a delay
- **`withAnimation(.easeInOut)`** — animating state changes smoothly
- **`.opacity()`** — fade in/out effects

### Layout & Styling
- **`LinearGradient`** — colorful gradient backgrounds
- **`.ignoresSafeArea()`** — extending backgrounds behind the status bar
- **`.scrollContentBackground(.hidden)`** — removing Form's default white background
- **`.cornerRadius()`**, **`.shadow()`**, **`.padding()`** — polishing UI elements
- **`.frame()`** — controlling view sizing

### Logic & Swift Concepts
- **`Int.random(in:)`** and **`CGFloat.random(in:)`** — generating random numbers
- **`Array.randomElement()`** — picking random items from a collection
- **`??` nil coalescing operator** — providing fallback values for optionals
- **`.onAppear`** — running code when a view appears on screen
- Understanding when to use **`@State`** vs plain `let` to prevent unwanted redraws

### Third Party Assets
- Importing and using **PNG assets** from [Kenney's Animal Pack Remastered](https://kenney.nl/assets/animal-pack-remastered) in Xcode's Asset Catalog
- Displaying images with **`Image()`**, `.resizable()`, `.scaledToFit()`, and `.frame()`

---

## 🛠 Built With

- Swift & SwiftUI
- Xcode
- [Kenney Animal Pack Remastered](https://kenney.nl/assets/animal-pack-remastered)

---

## 📚 Part of

[100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui) by Paul Hudson — Day 35 Milestone Project
