//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ivan Lara on 4/18/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button("Show alert") {
            showingAlert = true
        }
        .alert("Important message!", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("please read this")
        }
    }
}
    func executeDelete(){
        print("Now deleting...")
    }

#Preview {
    ContentView()
}
