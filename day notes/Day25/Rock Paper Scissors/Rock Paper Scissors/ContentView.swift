//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Ivan Lara on 5/9/26.
//

import SwiftUI

struct ContentView: View {
    
    let winningMoves = ["Paper", "Scissors", "Rock"]
    let moves = ["Rock", "Paper", "Scissors"]
    @State private var outcome = false
    @State private var currentScore = 0
    @State private var questionsAsked = 0
    @State private var randomMove = Int.random(in: 0..<3)
    @State private var playerHasChosen = false
    
    var body: some View {
        VStack {
            Text("Rock Paper Scissors")
                .font(.largeTitle)
            
            HStack {
                
                Button("Rock") {
                    playerHasChosen = true {
                        if moves[randomMove] == moves[0] || moves[1] {
                            currentScore += 1
                        } else {
                            currentScore -= 1
                        }
                    }
                }
                .padding()
                .frame(width: 100, height: 50)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Button("Paper") {
                    playerHasChosen = true
                }
                .padding()
                .frame(width: 100, height: 50)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
                Button("Scissors") {
                    playerHasChosen = true
                }
                .padding()
                .frame(width: 100, height: 50)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            if playerHasChosen {
                Text("Computer: \(moves[randomMove])")
            }
            
            VStack {
                Text("You \(outcome ? "Win" : "Lose")")
                Text("Your Score: \(currentScore)")
                Text("Round: \(questionsAsked)")
            }
        }
    }
}
#Preview {
    ContentView()
}
