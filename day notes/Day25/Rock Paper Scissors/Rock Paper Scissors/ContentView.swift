//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Ivan Lara on 5/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var moves = ["Rock", "Paper", "Scissors"]
    @State private var outcome = false
    @State private var currentScore = 0
    @State private var questionsAsked = 0
    @State private var randomMove = Int.random(in: 0..<3)
    
    var body: some View {
        VStack {
            VStack {
                Text("Rock Paper Scissors")
                    .font(.largeTitle)
            }
            
            HStack {
                    Text("Computer: \(moves[randomMove])")
                    Text("Player 1:") {
                        Button(moves
                    }
                }
            VStack {
                Text("Your Score: \(currentScore)")
                Text("Round: \(questionsAsked)")
            }
        }
    }
}
#Preview {
    ContentView()
}
