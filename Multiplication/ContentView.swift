//
//  ContentView.swift
//  Multiplication
//
//  Created by Waihon Yew on 06/06/2021.
//

import SwiftUI

struct ContentView: View {
  // App-level
  @State private var isSettings = true
  @State private var isActive = false
  // Game-level
  @State private var gameCompleted = false
  @State private var score = 0
  // Game- and question-level
  @State private var questionNumber = 0
  // Question-level
  @State private var multiplicant = 0
  @State private var multiplier = 0
  @State private var answer = 0
  @State private var correct = false
  @State private var answerChoice = ""
  // User input
  @State private var tablesChoice = 6
  @State private var questionsChoice = 0
    
  let questionsChoices  = ["5", "10", "15", "20", "All"]
  let multipliers = Array(1...12)
  
  var numberOfQuestions: Int {
    let choice = questionsChoices[questionsChoice].lowercased()
    if choice == "all" {
      return tablesChoice * 12
    } else {
      return Int(choice)!
    }
  }
  
  var randomMultiplicant: Int {
    Array(1...tablesChoice).randomElement()!
  }
  
  var randomMultiplier: Int {
    multipliers.randomElement()!
  }
  
  var body: some View {
    Group {
      if isSettings {
        NavigationView {
          Form {
            Section(header: Text("Which Multiplication Tables to Practice?")) {
              Stepper(value: $tablesChoice, in: 1 ... 12, step: 1) {
                Text("Up to \(tablesChoice)")
              }
            }
            Section(header: Text("How Many Questions?")) {
              Picker("Number of Questions", selection: $questionsChoice) {
                ForEach(0 ..< questionsChoices.count) {
                  Text("\(questionsChoices[$0])")
                }
              }
              .pickerStyle(SegmentedPickerStyle())
            }
            Section {
              Button("Start a Game") {
                startGame()
              }
            }
          }
          .navigationBarTitle(Text("Settings"))
        }
      } else if isActive {
        NavigationView {
          Form {
            Section(header: Text("Enter the result of \(multiplicant) x \(multiplier)")) {
              TextField("\(multiplicant) x \(multiplier) = ", text: $answerChoice, onCommit: checkAnswer)
                .keyboardType(.numberPad)
                .disabled(gameCompleted)
              Button("Submit") {
                checkAnswer()
              }
              .disabled(gameCompleted || answerChoice.isEmpty)
            }
            if gameCompleted {
              Section(header: Text("Score")) {
                Text("\(score) of \(numberOfQuestions)")
              }
              Button("Start a New Game") {
                newGame()
              }
            }
          }
          .navigationBarTitle(Text("Multiplication"))
        }
      } else {
        EmptyView()
      }
    }
  }
  
  func newGame() {
    isSettings = true
    isActive = false
  }
  
  func startGame() {
    isSettings = false
    isActive = true
    
    gameCompleted = false
    score = 0
    questionNumber = 0
    
    nextQuestion()
  }
  
  func nextQuestion() {
    questionNumber += 1
    
    if questionNumber <= numberOfQuestions {
      multiplicant = randomMultiplicant
      multiplier = randomMultiplier
      answer = multiplicant * multiplier
      correct = false
      answerChoice = ""
    } else {
      gameCompleted = true
    }
  }
  
  func checkAnswer() {
    guard !answerChoice.isEmpty else { return }

    if let userChoice = Int(answerChoice) {
      if userChoice == answer {
        correct = true
      }
    }
    
    if correct {
      score += 1
    }
    
    nextQuestion()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
