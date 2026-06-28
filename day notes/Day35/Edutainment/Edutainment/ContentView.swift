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
    let animal: String
}

struct DecorationAnimal {
    let name: String
    let x: CGFloat
    let y: CGFloat
}


struct ContentView: View {
    
    let animals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose", "narwal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus", "whale", "zebra"]
    
    @State private var upToTable = [2,3,4,5,6,7,8,9,10,11,12]
    @State private var upToTableSelected = 2
    @State private var numberOfQuestions = [5,10,20]
    @State private var numberofQuestionsSelected = 5
    @State private var score = 0
    @State private var isPlaying = false
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var showingAlert = false
    @State private var feedbackMessage = ""
    @State private var answerisCorrect = false
    @State private var decorationAnimals = [DecorationAnimal]()
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var body: some View {
        if isPlaying == false {
            ZStack {
                LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Image(animals.randomElement()!)
                    Text("EDUTAINMENT")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.purple)
                        .shadow(color: .black.opacity(0.8), radius: 10, x: 4, y: 4)
                    Image(animals.randomElement()!)
                    
                    Text("Master your multiplication tables!")
                        .frame(maxWidth: 300)
                        .foregroundStyle(Color.purple)
                        .cornerRadius(20)
                        .padding(.vertical, 8)
                        .font(Font.body.weight(.bold))
                    Form {
                        VStack {
                            Picker("Multiplication table number", selection: $upToTableSelected) {
                                ForEach(upToTable, id: \.self) {
                                    number in Text("\(number)")
                                }
                            }
                            
                        }
                        .font(Font.body.weight(.bold))
                        
                        VStack {
                            Text("Number of questions")
                            Picker("Number", selection: $numberofQuestionsSelected) {
                                ForEach(numberOfQuestions, id: \.self) {
                                    number in Text("\(number)")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        .font(Font.body.weight(.bold))
                    }
                    .scrollContentBackground(.hidden)
                    
                    Button("Start") {
                        questions = []
                        for _ in 1...numberofQuestionsSelected {
                            let first = Int.random(in: 1...upToTableSelected)
                            let second = Int.random(in: 1...upToTableSelected)
                            let animal = animals.randomElement() ?? "bear"
                            let newQuestion = Question(first: first, second: second, animal: animal)
                            questions.append(newQuestion)
                        }
                        isPlaying = true
                        print(questions)
                    }
                    .font(Font.body.weight(.bold))
                    .frame (maxWidth: 150, maxHeight:40)
                    .padding(10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }
        } else {
            
            ZStack {
                LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    if let question = currentQuestion {
                        Image(question.animal)
                        Text("What is \(question.first) x \(question.second)?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(20)
                        TextField("Your answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 200, maxHeight: 200)
                        
                        Button("Submit") {
                            let correctAnswer = question.first * question.second
                            let typedAnswer = Int(userAnswer) ?? 0
                            
                            if typedAnswer == correctAnswer {
                                showingAlert = true
                                feedbackMessage = "Correct!"
                                answerisCorrect = true
                                score += 1
                            } else {
                                showingAlert = true
                                feedbackMessage = "Incorrect!"
                                answerisCorrect = false
                                score -= 1
                            }
                            
                            userAnswer = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                withAnimation(.easeInOut) {
                                    showingAlert = false
                                }
                                currentQuestionIndex += 1
                            })
                        }
                        .fontWeight(.bold)
                        
                    } else {
                        ZStack {
                            ForEach(0..<decorationAnimals.count, id: \.self) {
                                i in Image(decorationAnimals[i].name)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .offset(x: decorationAnimals[i].x, y: decorationAnimals[i].y)
                                    .opacity(0.3)
                            }
                            
                            VStack {
                                
                                Text("Game Over!")
                                    .font(.title.bold())
                                    
                                Button("Play again?") {
                                    isPlaying = false
                                    
                                    score = 0
                                    currentQuestionIndex = 0
                                }
                                .font(Font.body.weight(.bold))
                                .frame (maxWidth: 150, maxHeight:40)
                                .padding(10)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                        }
                        
                        .onAppear {
                            decorationAnimals = []
                            for _ in 1...300 {
                                let animal = DecorationAnimal(name: animals.randomElement() ?? "bear", x: CGFloat.random(in: -300...300), y: CGFloat.random(in: -500...500)
                                )
                                decorationAnimals.append(animal)
                            }
                        }
                    }
                    
                    Text("Score: \(score)")
                        .fontWeight(.bold)
                }
            }
            .overlay(
                Group {
                    if showingAlert {
                        Text(feedbackMessage)
                            .font(.headline)
                            .padding()
                            .background(answerisCorrect ? Color.green.opacity(1.0) : Color.red.opacity(1.0))
                            .cornerRadius(10)
                    }
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
