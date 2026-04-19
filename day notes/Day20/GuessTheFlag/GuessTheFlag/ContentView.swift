//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ivan Lara on 4/18/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 70) {
            
            VStack(spacing: 50){
                Text("First")
                Text("Second")
                Text("Third")
            }
            
            VStack(spacing: 50){
                Text("First")
                Text("Second")
                Text("Third")
            }
            
            VStack(spacing: 50) {
                Text("First")
                Text("Second")
                Text("Third")
            }
        }
    }
}
        
#Preview {
    ContentView()
}
