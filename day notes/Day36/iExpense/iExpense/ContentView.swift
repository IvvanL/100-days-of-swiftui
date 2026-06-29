//
//  ContentView.swift
//  iExpense
//
//  Created by Ivan Lara on 6/27/26.
//
 
import SwiftUI

struct ContentView: View {
    @AppStorage("Tap Count") private var tapCount = 0
    
    var body: some View {
        Button("Tap count: \(tapCount)") {
            tapCount += 1
        }
    }
}
    

#Preview {
    ContentView()
}
