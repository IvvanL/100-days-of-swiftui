//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ivan Lara on 4/18/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.yellow.opacity(0.37)
                Color.black
            }
            
            Text("Lia Lara Events")
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
    }
}
        
#Preview {
    ContentView()
}
