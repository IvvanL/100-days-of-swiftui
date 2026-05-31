//
//  ContentView.swift
//  WordScramble
//
//  Created by Ivan Lara on 5/25/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello World!")
        }
        .padding()
    }
    
    func testStrings() {
        let word = "swift"
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0,wrap: false,language: "en")
        
        let allGood = mispelledRange.location == NSNotFound
    }
}

#Preview {
    ContentView()
}
