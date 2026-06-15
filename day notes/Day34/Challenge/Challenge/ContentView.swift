//
//  ContentView.swift
//  Challenge
//
//  Created by Ivan Lara on 6/14/26.
//
/*
DAY 34 CHALLENGE
 - 1. When you tap a flag, make it spin around 360 degrees on the Y axis (i made it 720 for more effects).
 - 2. Make the other two buttons fade out to 25% opacity.
 - 3. Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
    + I made the unselected flags get smaller and darker on user input
 */


import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var userScore = 0 // stors users score
    @State private var questionsAsked = 0 // tracks questions asked
    @State private var gameOver = false // tracks if the game is over
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var animationAmounts = [0.0, 0.0, 0.0] // this array keeps track of all 3 separate flags, otherwise all 3 would spin at the same time
    
    @State private var selectedFlag: Int? = nil
    @State private var scaleAmounts = [1.0, 1.0, 1.0] // tracks scale amounts

    
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
                            withAnimation (.spring(duration: 1, bounce: 0.50)) {
                                animationAmounts[number] += 720 // when the flag is tapped it spings it by 360 degrees
                                for i in 0..<3 {
                                    if i != number { // this says that if its the flag that is not picked it will scale and flip it
                                          scaleAmounts[i] = 0.50
                                        }
                                    }
                                }
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                    .shadow(radius: 10)
                                    .rotation3DEffect(.degrees(animationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                                    .overlay(
                                        Capsule()
                                            .fill(.black.opacity(selectedFlag != nil && number != selectedFlag ? 0.25 : 0.0))
                                    )
                                    .scaleEffect(scaleAmounts[number])
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
        
        selectedFlag = number
        
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
    
    func resetGame(){
        selectedFlag = nil //resets the opacity
        questionsAsked = 0
        userScore = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        scaleAmounts = [1.0, 1.0, 1.0]
    }
    
    func askQuestion() {
        selectedFlag = nil //resets the opacity
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        scaleAmounts = [1.0, 1.0, 1.0]
    }
}

#Preview {
    ContentView()
}

