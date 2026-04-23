//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Ivan Lara on 4/18/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button {
            print("Button was tapped")
        } label: {
            Label("Edit", systemImage: "pencil")
                .padding()
                .foregroundStyle(.white)
                .background(.red)
        }
    }
}
    func executeDelete(){
        print("Now deleting...")
    }

#Preview {
    ContentView()
}
