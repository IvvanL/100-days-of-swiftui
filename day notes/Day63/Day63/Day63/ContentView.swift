//
//  ContentView.swift
//  Day63
//
//  Created by Ivan Lara on 11/15/26.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("You don't have any saved snippets yet.")
        } actions: {
            Button("Create snippet") {
                //create a snippet
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
