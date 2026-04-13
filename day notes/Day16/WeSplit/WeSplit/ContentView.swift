//
//  ContentView.swift
//  WeSplit
//
//  Created by Ivan Lara on 4/12/26.
//

import SwiftUI

struct ContentView: View { //basic protocol
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Hello World")
                }
                
                Section {
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                }
                
                Section {
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                    Text("Hello World")
                }
            }
            .navigationTitle("SwiftUI")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
