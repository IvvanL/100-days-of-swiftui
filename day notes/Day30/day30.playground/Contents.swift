// ** DAY 30 - PROJECT 5 - WORD SCRAMBLE - PART 2 **

// ** ADDING TO A LIST OF WORDS **

/* import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
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
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        }
    }

#Preview {
    ContentView()
}

*/

// State Properties
// - usedWords: [String] - stores submitted words
// - rootWord: String - the word users spell from
// - newWord: String - bound to the text field

// UI structure
// - NavigationStack with rootWord as title
// - List with two sections: a TextField and a ForEach over usedWords

// addNewWord() Logic
// 1. Lowercase + trim whitespace - normalizes input so "Car", "CAR", and "car" aren't treated as different words
// 2. Guard against empty string - exits early if there's nothing meaningful to add
// 3. insert at index 0 (so new words appear at the top) - adds the word to the front of the array so it appears at the top of the list immediately, rather than appending to the bottom where it may be off-screen
// 4. reset newWord to "" - clears the text field after submission

// Key Modifiers
// - .onSubmit(addNewWord) - triggers submission on keyboard return
// - .textInputAutocapitalization(.never) - prevents capitalization mismatch
// - withAnimation {} arround insert() - animates new words into the list

// SF Symbols Tip
// - wrap each word in an HStack with Image(systemName: "\(word.count).circle") to show a word length visually(works for lengths 0-50)


// ** RUNNING CODE WHEN OUR APP LAUNCHES **

/* import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
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
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    }

#Preview {
    ContentView()
}

*/

// core concepts:
// - Use startGame() + .onAppear to load and initialize game data when a view appears

// app bundle basics:
// - Xcode packages your compiled app, assets and files into a .app bundle. You can access bundled files at runtime via Bundle.main

// The startGame() Method
// + Four steps to load a word list from start.txt:
// 1. find the file - get its URL from the app bundle
// 2. Load it - read contents into a String
// 3. SPlit it - use .components(separatedBy: "\n") to get an array of words
// 4. Pick one - use .randomElement() ?? "silkworm" (default if array is empty)

// fatalError() - crashing intentionally
// - used when a problem is unrecoverable (ex. a required file is missing). rather than letting the app limp along in a broken state, fatalError() crashes immediately with a clear message - making bugs obvious during development

// triggering on launch:
// - attach .onAppear to a view to call startGame() when the view first loads:

// .onAppear(perform: startGame)

// ** VALIDATING WORDS WITH UITextChecker **

/*
import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
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
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
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
        
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
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
*/

// Word Scrabble - Validating User Input
// - 3 validartion methods are added to check submitted words:
// 1. isOriginal - checks the word hasnt been used already (usedWords.contains())
// 2. isPossible - checks the word can actually be formed from the root word's letter (loops through each letter, removing matches from a temp copy)
// 3. isReal - uses UITextChecker to verify it's a real English word via rangeOfMispelledWord(); valid words return NSNotFound as the location

// - a 4th helper, wordError, centralizes alert display by setting errorTitle, errorMessage, and flipping showingError to true. An .alert() modifier reads these to show the appropriate message.
// - all 3 checks are applied in addNewWord() using gaurd statements - failing any one returns early with a descriptive error alert
