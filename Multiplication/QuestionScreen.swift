//
//  QuestionScreen.swift
//  Multiplication
//
//  Created by Farhad Bagherzadeh on 16/11/2022.
//

import SwiftUI

struct Question {
  let number: Int
  let multiplyBy: Int
  let questionTitle: String

  init(number: Int, multiplyBy: Int) {
    self.number = number
    self.multiplyBy = multiplyBy
    let numberFirst: Bool = .random()
    questionTitle = "\(numberFirst ? number : multiplyBy) X \(numberFirst ? multiplyBy : number) = "
  }

  var answer: Int {
    number * multiplyBy
  }
}

struct QuestionScreen: View {
  @Binding var showGame: Bool
  let tablesUpTo: Int
  let numberOfQuestions: Int

  @State private var askingQuestionIndex: Int = 1
  @State private var answer: String = ""
  @State private var score: Int = 0
  @State private var questions: [Question] = []
  @State private var currentQuestion: Question = .init(number: 1, multiplyBy: 1)


  @State private var showAlert: Bool = false
  @FocusState private var isFocused: Bool

  @State private var newQuestionPicked: Bool = false
  @State private var animatingIncreaseScore = false
  @State private var animatingDecreaseScore = false

  var body: some View {
    VStack {
      answerView
      infoView
      thumbsView
      Spacer()
      submitButton
    }
    .padding(.top)
    .alert(Text("Game over!"), isPresented: $showAlert) {
      Button("Ok", role: .none) {
        showGame = false
      }
    }
    .onAppear {
      isFocused = true
      createQuestions()
      pickQuestion()
    }
  }
}

private extension QuestionScreen {
  func createQuestions() {
    for i in (1...tablesUpTo) {
      for j in (1...12) {
        questions.append(.init(number: i, multiplyBy: j))
      }
    }
  }

  func pickQuestion() {
    questions.shuffle()
    currentQuestion = questions.removeFirst()
  }

  func didSubmit() {
    guard let validAnswer = Int(answer) else { return }
    newQuestionPicked = false
    animatingIncreaseScore = false
    animatingDecreaseScore = false

    if validAnswer == currentQuestion.answer {
      score += 1
      withAnimation(Animation.linear(duration: 1)) {
        animatingIncreaseScore = true
      }
    } else {
      score -= 1
      withAnimation(Animation.linear(duration: 1)) {
        animatingDecreaseScore = true
      }
    }

    pickQuestion()
    newQuestionPicked = true
    answer = ""
    askingQuestionIndex += 1
    showAlert = numberOfQuestions == askingQuestionIndex
  }
}

private extension QuestionScreen {
  @ViewBuilder var thumbsView: some View {
    ZStack {
      thumbsupView
      thumbsdownView
    }
  }

  var thumbsupView: some View {
    Image(systemName: "hand.thumbsup")
      .resizable()
      .frame(width: 30, height: 30)
      .foregroundColor(animatingIncreaseScore ? .green : .clear)
      .offset(x: .zero, y: animatingIncreaseScore ? 0 : 70)
      .opacity(animatingIncreaseScore ? 0 : 1)
  }

  var thumbsdownView: some View {
    Image(systemName: "hand.thumbsdown")
      .resizable()
      .frame(width: 30, height: 30)
      .foregroundColor(animatingDecreaseScore ? .red : .clear)
      .offset(x: .zero, y: animatingDecreaseScore ? 140 : 70)
      .opacity(animatingDecreaseScore ? 0 : 1)
  }

  var answerView: some View {
    VStack(alignment: .leading, spacing: 1) {
      Text("Question \(askingQuestionIndex)/\(numberOfQuestions)")
        .animation(.default, value: newQuestionPicked)
        .font(.caption)
        .padding(.horizontal)

      HStack {
        Text(currentQuestion.questionTitle)
          .animation(.default, value: newQuestionPicked)

        TextField("answer", text: $answer)
          .focused($isFocused)
          .keyboardType(.numberPad)
      }
      .font(.title)
      .padding()
      .background(Color.secondary.opacity(0.1))
      .cornerRadius(10)
      .padding(.horizontal)
    }
  }

  var infoView: some View {
    VStack(alignment: .center) {
      HStack {
        Text("Your score: \(score)")
      }
    }
    .padding()
  }

  var submitButton: some View {
    Button(action: didSubmit) {
      Text("Submit")
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
  }
}

struct QuestionScreen_Previews: PreviewProvider {
  static var previews: some View {
    QuestionScreen(showGame: .constant(false), tablesUpTo: 1, numberOfQuestions: 5)
  }
}
