//
//  ContentView.swift
//  Edutainment
//
//  Created by Ivan Lara on 6/20/26.
//

import SwiftUI

struct Question {
    let first: Int
    let second: Int
}

struct ContentView: View {
    
    @State private var upToTable = [2,3,4,5,6,7,8,9,10,11,12]
    @State private var upToTableSelected = 2
    @State private var numberOfQuestions = [5,10,20]
    @State private var numberofQuestionsSelected = 5
    @State private var score = 0
    @State private var isPlaying = false
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        if isPlaying == false {
            VStack {
                Text("EDUTAINMENT")
            }
            
            Form {
                VStack {
                    Text("Pick your multiplication table!")
                    Picker("Table Number", selection: $upToTableSelected) {
                        ForEach(upToTable, id: \.self) {
                            number in Text("\(number)")
                        }
                    }
                }
                
                VStack {
                    Text("Number of questions")
                    Picker("Number", selection: $numberofQuestionsSelected) {
                        ForEach(numberOfQuestions, id: \.self) {
                            number in Text("\(number)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            
            VStack {
                Button("Start") {
                    questions = []
                    for _ in 1...numberofQuestionsSelected {
                        let first = Int.random(in: 1...upToTableSelected)
                        let second = Int.random(in: 1...upToTableSelected)
                        let newQuestion = Question(first: first, second: second)
                        questions.append(newQuestion)
                    }
                    isPlaying = true
                    print(questions)
                    
                }
            }
            
            } else {
                VStack {
                    if let question = currentQuestion {
                        Text("What is \(question.first) x \(question.second)?")
                            .font(.title)
                        
                        TextField("Your answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                        Button("Submit") {
                            let correctAnswer = question.first * question.second
                            let typedAnswer = Int(userAnswer) ?? 0
                            
                            if typedAnswer == correctAnswer {
                                score += 1
                            } else {
                                score -= 1
                            }
                            
                            userAnswer = ""
                            currentQuestionIndex += 1
                        }
                    } else {
                        Text("Game Over!")
                        Button("Play again?") {
                            isPlaying = false
                            
                            score = 0
                            currentQuestionIndex = 0
                        }
                        .tint(Color.green)
                    }
                    
                    Text("Score: \(score)")
                }
            }
        }
    }

#Preview {
    ContentView()
}
