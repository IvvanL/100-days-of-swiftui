import Cocoa

/*
 ** PROJECT 2: GUESS THE FLAG, PART 3 **
 
 ** Wrap Up: REVIEW OF PROJECT 2 **
 
 - completed short test on things i learned on days 20 and 21
 - completed day 22 challenge
 
 Challenge:
 1. Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label.
 
 2. When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
 
 3. Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game.


Updated code:

 import SwiftUI

 struct ContentView: View {
     @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
     @State private var correctAnswer = Int.random(in: 0...2)
     
     @State private var userScore = 0 // stors users score
     @State private var questionsAsked = 0 // tracks questions asked
     @State private var gameOver = false // tracks if the game is over
     
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
                 
                 Text("Score: \(userScore)")
                     .foregroundStyle(.white)
                     .font(.title.bold())
                 
                 Spacer()
             }
             .padding()
         }
         .alert(scoreTitle, isPresented: $showingScore) {
             Button("Continue", action: askQuestion)
         } message: {
             Text("Your score is \(userScore)") // shows user score in pop up window
         }
         .alert("Game Over!", isPresented: $gameOver) { // new alert if 8 questions have been answered and user chooses to play again
             Button("Play Again", action: resetGame)
         } message: {
             Text("Your final score is \(userScore)/8")
         }
     }
     
     func flagTapped(_ number: Int) {
         
         if number == correctAnswer {
             scoreTitle = "Correct"
             userScore += 1 // add to userScore here
         } else {
             scoreTitle = "Wrong! That's the flag of \(countries[number])" // if user chooses wrong, it shows which country the user picked
             userScore -= 1 // substract from userScore here (optional, or just don't add)
         }
         
         questionsAsked += 1
         
         if questionsAsked == 8 {
             gameOver = true
             return
         }
         
         showingScore = true
     }
     
     func resetGame(){ // function that resets game
         questionsAsked = 0
         userScore = 0
         countries.shuffle()
         correctAnswer = Int.random(in: 0...2)
     }
     
     func askQuestion() {
         countries.shuffle()
         correctAnswer = Int.random(in: 0...2)
     }
 }

 #Preview {
     ContentView()
 }
