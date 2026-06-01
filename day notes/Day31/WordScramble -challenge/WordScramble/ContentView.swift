//
//  ContentView.swift
//  WordScramble
//
//  Created by Ivan Lara on 5/25/26.
//

/* DAY 31 CHALLENGE:
 
 1. Disallow answers that are shorter than three letters or are just our start word.
 
 answer: added one more guard to addNewWord func and added a new func for isLong, to check to see if the word is at least 3 letters long
 
 2. Add a toolbar button that calls startGame(), so users can restart with a new word whenever they want to.
 
 answer: added toolbar button that calls on the start game logic and also clears the board of any previously submitted words
 
 3. Put a text view somewhere so you can track and show the player’s score for a given root word. How you calculate score is down to you, but something involving number of words and their letter count would be reasonable.
 
 personal challenges:
    + added a scrabble title
    + added dark mode/light mode toggle
    + added a final score pop up with a play again button
    + added a timer
 
 */

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0 //challenge 3 - added a score state
    
    @State private var isDarkMode = false
    @State private var finalScore = false
    @State private var timeRemaining = 20
    @State private var gameTimer: Timer?
    
    var body: some View {
        
        Text("SCRABBLE!!")
            .font(Font.largeTitle.bold())
        
        Button {
            isDarkMode.toggle()
        } label: {
            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
        }
        
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok") {}
            } message: {
                Text(errorMessage)
            }
            .alert("Your final score is: \(score)", isPresented: $finalScore) {
                Button("Play again?") {
                    startGame()
                    usedWords = []
                    score = 0
                }
            }
            
            
            Text("Time remaining: \(timeRemaining)")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.black)
                .foregroundColor(.red)
            
            .toolbar { // challenge 2 - added a restart game button
                ToolbarItem {
                    Button("Restart Game!") {
                        finalScore = true
                    }
                    .padding(115)
                    .background(Color.blue)
                    .tint(Color.white)
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        
        Section { // Challenge 3 - added a score tracking section at the bottom
            Text("Score: \(score)")
                .padding(30)
                .frame(width: 5000, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .font(Font.largeTitle.bold())
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isLong(word: answer) else { //challenge 1, added guard
            wordError(title: "word needs to be longer!", message: "Try again")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "word used already", message: "Be more original")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        score += 1 //Challenge 3 - added logic so that it adds a point for every correct word
        newWord = ""
    }
    
    func startGame() {
        gameTimer?.invalidate()
        timeRemaining = 20
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        timer.invalidate()
                        self.finalScore = true
                    }
                }
                
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isLong(word: String) -> Bool { //challenge 1, added func for new guard
        if word.count >= 3 {
            return true
        } else {
            return false
        }
    }
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
