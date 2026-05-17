//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Ivan Lara on 5/9/26.
//

import SwiftUI

struct ContentView: View {

    let moves = ["Rock", "Paper", "Scissors"]
    
    @State private var currentScore = 0
    @State private var questionsAsked = 0
    @State private var randomMove = Int.random(in: 0..<3)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var gameOver = false
    @State private var playerHasChosen = false
    @State private var computerMove = ""
    @State private var isDarkMode: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: isDarkMode ? [.black, .blue] : [.cyan, .white],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Button {
                    isDarkMode.toggle()
                } label: {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.title)
                        .foregroundColor(isDarkMode ? .yellow : .orange)
                }
                Spacer()
                Text("Rock Paper Scissors")
                    .font(.largeTitle)
                
                VStack {
                    Button("Rock 🪨") {
                        playerTapped("Rock")
                    }
                    .padding()
                    .frame(width: 125, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    
                    Button("Paper 📄") {
                        playerTapped("Paper")
                    }
                    .padding()
                    .frame(width: 125, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    
                    Button("Scissors ✂️") {
                        playerTapped("Scissors")
                    }
                    .padding()
                    .frame(width: 125, height: 50)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                    
                }
                .padding()
                Spacer()
                VStack {
                    if playerHasChosen {
                        Text("Computer: \(moves[randomMove])")
                    }
                    Text("Your Score: \(currentScore)")
                    Text("Round: \(questionsAsked)")
                }
                .font(.headline)
            }
        }
        
        
        .preferredColorScheme(isDarkMode ? .dark :.light)
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Computer chose \(computerMove). Your score is \(currentScore)")
        }
        .alert("GAME OVER", isPresented: $gameOver) {
            Button("Play Again", action: resetGame)
            Button("Quit", role: .destructive) {
                gameOver = false
                resetGame()
            }
        } message: {
            Text("Final Score: \(currentScore)")
        }
    }
    func playerTapped(_ move: String) {
        playerHasChosen = true
        computerMove = moves[randomMove]
        
        if move == computerMove {
            scoreTitle = "Draw!"
        } else if (move == "Rock" && computerMove == "Scissors") ||
                  (move == "Paper" && computerMove == "Rock") ||
                  (move == "Scissors" && computerMove == "Paper") {
            scoreTitle = "You Win!"
            currentScore += 1
        } else {
            scoreTitle = "You Lose!"
            currentScore -= 1
        }
        
        questionsAsked += 1
        
        if questionsAsked == 10 {
            gameOver = true
        } else {
            showingScore = true
        }
    }
    
    func resetGame() {
        currentScore = 0
        questionsAsked = 0
    }
    
    func askQuestion() {
        randomMove = Int.random(in: 0..<3)
        playerHasChosen = false
    }
}

#Preview {
    ContentView()
}
