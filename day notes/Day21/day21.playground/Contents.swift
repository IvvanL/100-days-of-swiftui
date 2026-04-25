import Cocoa

/*
 
 **DAY 21 PROJECT 2, PART 2 GUESS THE FLAG**
 
 **STACKING UP BUTTONS**
 
 - import SwiftUI
 
 struct ContentView: View {
 var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
 var correctAnswer = Int.random(in: 0...2)
 
 var body: some View {
 ZStack {
 Color.blue
 .ignoresSafeArea()
 
 VStack(spacing: 30) {
 VStack {
 Text("Tap the flag of")
 .foregroundStyle(.white)
 
 Text(countries[correctAnswer])
 .foregroundStyle(.white)
 }
 
 ForEach(0..<3) { number in
 Button {
 //flag was tapped
 } label: {
 Image(countries[number])
 }
 }
 }
 }
 }
 }
 #Preview {
 ContentView()
 }
 
 - key properties
 + countries array - holds all country name strings
 + correctAnswer - uses Int.random(in: 0...2) to randomly pick which flag is correct
 
 - layout structure
 + Inner VStack - holds the two text lables with no spacing
 + Outer VStack(spacing: 30) - wraps the inner VStack + ForEach flag buttons with 30pt spacing
 + ZStack - layers the blue background behind everything
 + ForEach(0..<3) - lloops 3 times to generate 3 flag buttons
 
 - nested stacks are used because different spacing needs for differnt secitons - nesting VStacks gives more precise control
 
 - Polish
 + Color.blue.ignoresSafeArea() - fills entire screen including safe areas
 + .foregroundStyle(.white) - makes text visible against the dark background
 
 TLDR -ZStack -> blue bg + VStack(30) -> Inner VStack(text labels) + ForEach (flag buttons)
 
 
 **SHOWING THE PLAYERS SCORE WITH AN ALERT**
 
 import SwiftUI
 
 struct ContentView: View {
 @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
 @State private var correctAnswer = Int.random(in: 0...2)
 
 @State private var showingScore = false
 @State private var scoreTitle = ""
 
 var body: some View {
 ZStack {
 Color.blue
 .ignoresSafeArea()
 
 VStack(spacing: 30) {
 VStack {
 Text("Tap the flag of")
 .foregroundStyle(.white)
 
 Text(countries[correctAnswer])
 .foregroundStyle(.white)
 }
 
 ForEach(0..<3) { number in
 Button {
 flagTapped(number)
 } label: {
 Image(countries[number])
 }
 }
 }
 }
 .alert(scoreTitle, isPresented: $showingScore) {
 Button("Continue", action: askQuestion)
 } message: {
 Text("Your score is ???")
 }
 }
 
 func flagTapped(_ number: Int) {
 if number == correctAnswer {
 scoreTitle = "Correct"
 } else {
 scoreTitle = "Wrong"
 }
 
 showingScore = true
 }
 
 func askQuestion() {
 countries.shuffle()
 correctAnswer = Int.random(in: 0...2)
 }
 }
 #Preview {
 ContentView()
 }
 
 + shuffled flags
 - added .shuffled() to the countries array so flags appear in random order each round
 - mark both countries and correctAnswer as @State private var so SwiftUI can update the UI when they change
 
 + new @State properties
 - showingScore: Bool - controls whether the alert is visible
 scoreTitle: String - holds "Correct" or "Wrong" to display in the alert
 
 + flagTapped(_ number:int)
 - called when a flag button is tapped, receives the buttons index
 - compares tapped number against correctAnswer
 - sets scoreTitle to "Correct" or "Wrong"
 - Sets showingScore = true to trigger the alert
 
 + askQuestion()
 - called when the alert is dismissed
 - reshuffles countries array
 - Picks a new correctAnswer with Int.random(in: 0...2)
 - resets the game for the next round
 
 + Alert setup
 - .alert() modifier attached to the ZStack
 - isPresented: $showingScore - shows when true, hides when dismissed
 - continue button triggers askQuestion()
 - Score messaghe shows ??? for now - to be implemented later
 
 flow: tap flag -> flagTapped() -> alert appears -> tap continue -> asQuestion() -> new round
 
 
 ** STYLING OUR FLAGS**
 
 import SwiftUI
 
 struct ContentView: View {
 @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
 @State private var correctAnswer = Int.random(in: 0...2)
 
 @State private var showingScore = false
 @State private var scoreTitle = ""
 
 var body: some View {
 ZStack {
 LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
 .ignoresSafeArea()
 
 VStack(spacing: 30) {
 VStack {
 Text("Tap the flag of")
 .foregroundStyle(.white)
 .font(.subheadline.weight(.heavy))
 
 Text(countries[correctAnswer])
 .foregroundStyle(.white)
 .font(.largeTitle.weight(.semibold))
 }
 
 ForEach(0..<3) { number in
 Button {
 flagTapped(number)
 } label: {
 Image(countries[number])
 .clipShape(.capsule)
 .shadow(radius: 5)
 }
 }
 }
 }
 .alert(scoreTitle, isPresented: $showingScore) {
 Button("Continue", action: askQuestion)
 } message: {
 Text("Your score is ???")
 }
 }
 
 func flagTapped(_ number: Int) {
 if number == correctAnswer {
 scoreTitle = "Correct"
 } else {
 scoreTitle = "Wrong"
 }
 
 showingScore = true
 }
 
 func askQuestion() {
 countries.shuffle()
 correctAnswer = Int.random(in: 0...2)
 }
 }
 #Preview {
 ContentView()
 }
 
 + Background Gradient
 - repalce Color.blue with LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
 - keeps .ignoresSafeArea() so it still fills edge to edge
 - ensures flags with blue stripes still stand out
 
 + Typography
 - "Tap the flag of" -> .font(.subheadline.weight(.heavy)) - smaller but bold
 - Country name -> .font(.largeTitle.weight(.semibold)) - largest built-in IOS font size
 - largeTitle supports Dynamic Type - automatically scales based on users font settings
 
 + Flag image styling two modifiers added to each flag image:
 - .clipShape(.capsule) - rounds the shortest edges fully, keeps long edges straight, great for buttons
 - .shadows(radius: 5) - adds a subtle translucent black shadows, no X/Y offset needed
 
 Final Flag code:
 
 Image(countries[number])
 .clipShape(.capsule)
 .shadow(radius: 5)
 
 
 ** UPGRADING OUR DESIGN **
 
 import SwiftUI
 
 struct ContentView: View {
 @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
 @State private var correctAnswer = Int.random(in: 0...2)
 
 @State private var showingScore = false
 @State private var scoreTitle = ""
 
 var body: some View {
 ZStack {
 RadialGradient(stops: [
 .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
 .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
 ], center: .top, startRadius: 200, endRadius: 700)
 .ignoresSafeArea()
 
 VStack {
 Spacer()
 
 Text("Gues the Flag")
 .font(.largeTitle.weight(.bold))
 .foregroundStyle(.white)
 
 VStack(spacing: 15) {
 VStack {
 Text("Tap the flag of")
 .foregroundStyle(.secondary)
 .font(.subheadline.weight(.heavy))
 
 Text(countries[correctAnswer])
 .font(.largeTitle.weight(.semibold))
 }
 
 ForEach(0..<3) { number in
 Button {
 flagTapped(number)
 } label: {
 Image(countries[number])
 .clipShape(.capsule)
 .shadow(radius: 10)
 }
 }
 }
 .frame(maxWidth: .infinity)
 .padding(.vertical, 20)
 .background(.regularMaterial)
 .clipShape(.rect(cornerRadius: 20))
 
 Spacer()
 Spacer()
 
 Text("Score: ???")
 .foregroundStyle(.white)
 .font(.title.bold())
 
 Spacer()
 }
 .padding()
 }
 .alert(scoreTitle, isPresented: $showingScore) {
 Button("Continue", action: askQuestion)
 } message: {
 Text("Your score is ???")
 }
 }
 
 func flagTapped(_ number: Int) {
 if number == correctAnswer {
 scoreTitle = "Correct"
 } else {
 scoreTitle = "Wrong"
 }
 
 showingScore = true
 }
 
 func askQuestion() {
 countries.shuffle()
 correctAnswer = Int.random(in: 0...2)
 }
 }
 
 #Preview {
 ContentView()
 }
 
 + Background - radial gradient
 - replace linear gradient with a RadialGradient using two stops at the same location (0.3) to create a hard color switch instead of a blend
 - use muted custom RGB colors instead of bright red/blue for a more harmonious look
 
 RadialGradient(stops: [
 .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
 .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
 ], center: .top, startRadius: 200, endRadius: 400)
 
 + Flag Box Styling
 - reduce inner VStack spacing from 30 -> 15
 - add these modifiers ot make it a styled card:
 
 .frame(maxWidth: .infinity)
 .padding(.vertical, 20)
 .background(.regularMaterial)
 .clipShape(.rect(cornerRadius: 20))
 
 + New outer VStack
 - Wrap everything in a new VStack containing:
 + "Guess the flag" title at the top - .font(.largeTitle.bold()) in white
 + The existingj flag box  in the middle
 + "Score: ???" label at the bottom - .font(.title.bold()) in white
 
 + Text color Fixes
 - Country name - remove .foregroundStyle(.white) let it default to system primary color (black/white based on light/dark mode)
 - "Tap the flag of" - change to .foregroundStyle(.secondary) for IOS vibrancy effect
 
 + Spacing with spacers add Spacer() views to spread content evenly across all screen sizes:
 - 1 before the title
 - 2 before the score label
 - 1 after the score label
 
 - multiple sopacers divide available space equally  - 2 together take up twice the space of 1
 
 + FInal touch
 - add .padding() to the outermost VStack to prevent content from touching screen edges
