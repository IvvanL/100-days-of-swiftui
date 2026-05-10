//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Ivan Lara on 5/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var Rock = ["Rock", "Paper", "Scissors"]
    @State private var ChoiceWinner = "Winner"
    @State private var ChoiceLoser = "Loser "
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
