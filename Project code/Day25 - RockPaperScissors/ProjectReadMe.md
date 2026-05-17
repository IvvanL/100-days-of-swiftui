# Day 25 - Rock Paper Scissors Challenge Project

## 📱 About
A Rock Paper Scissors game built with SwiftUI. 
The player competes against the computer over 10 rounds, 
with a running score tracked throughout.

## 🎮 How to Play
- The computer randomly picks Rock, Paper, or Scissors
- Tap your move to play against it
- Win a round to gain a point, lose a round to lose a point, or draw
- After 10 rounds your final score is revealed

## ✨ Features
- 🎲 Random computer move each round
- 🌙 Dark/Light mode toggle
- 📊 Live score and round tracking
- 🏆 Game over screen with final score
- 🔄 Play again or quit after game ends

## 📸 Screenshots
### Light Mode
![Light Mode](screenshots/lightmode.png)

### Dark Mode
![Dark Mode](screenshots/darkmode.png)

### Gameplay
![Gameplay](screenshots/pic1.png)

### Win/Lose Alert
![Alert](screenshots/pic2.png)

### Game Over
![Game Over](screenshots/gameover.png)

## 🧠 What I Learned

### SwiftUI Fundamentals
- Using `@State` to manage game data that changes during gameplay
- Using `let` for data that never changes (moves array)
- Rebuilding views automatically when `@State` variables change

### Game Logic
- Using `Int.random(in:)` to pick a random computer move
- Using `Bool.random()` to randomize outcomes
- Using `.toggle()` to flip boolean values between rounds
- Comparing strings to determine win/lose/draw outcomes

### UI & Layout
- Layering views with `ZStack` for gradient backgrounds
- Organizing layouts with `VStack` and `HStack`
- Using `if` statements inside views to conditionally show/hide content
- Using `.ignoresSafeArea()` to extend backgrounds edge to edge

### Styling & Animation
- Using `.preferredColorScheme` for dark/light mode switching
- Using SF Symbols with `Image(systemName:)` for the sun/moon toggle
- Using ternary operators for dynamic styling

### Alerts & User Interaction
- Presenting alerts with `.alert` and `isPresented`
- Using `Button` roles (`.destructive`) for styled alert buttons
- Chaining multiple `.alert` modifiers for different game states

### Functions
- Breaking logic into reusable functions (`playerTapped`, `askQuestion`, `resetGame`)
- Passing data into functions with parameters

## 🛠 Built With
- Swift
- SwiftUI
- Xcode
