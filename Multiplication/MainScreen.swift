//
//  ContentView.swift
//  Multiplication
//
//  Created by Farhad Bagherzadeh on 16/11/2022.
//

import SwiftUI

struct MainScreen: View {
  private let numbers: [Int] = [5, 10, 20]
  @State private var tablesUpTo: Int = 1
  @State private var numberOfQuestions: Int = 5

  @State private var showGame: Bool = false

  var body: some View {
    NavigationView {
      VStack {
        tablesUpToView
        numberOfQuestionsView
        Spacer()
        startButtonView
      }
      .padding(.top)
      .navigationTitle("Multiplication")
    }
    .navigationViewStyle(.stack)
  }
}

private extension MainScreen {
  var tablesUpToView: some View {
    VStack(alignment: .leading) {
      Text("Tables up to:")
      Stepper("\(tablesUpTo)", value: $tablesUpTo, in: 1...12)
    }
    .padding()
    .background(Color.secondary.opacity(0.1))
    .cornerRadius(10)
    .padding(.horizontal)
  }

  @ViewBuilder var numberOfQuestionsView: some View {

    VStack(alignment: .leading) {
      Text("Number of questions:")
      Picker("", selection: $numberOfQuestions) {
        ForEach(numbers, id: \.self) {
          Text("\($0)")
        }
      }
      .pickerStyle(.segmented)
    }
    .padding()
    .background(Color.secondary.opacity(0.1))
    .cornerRadius(10)
    .padding(.horizontal)
  }

  var startButtonView: some View {
    ZStack {
      NavigationLink(
        "",
        destination: questionScreen,
        isActive: $showGame
      )
      Button(action: { showGame.toggle() }) {
        Text("Start")
          .frame(height: 44)
          .frame(maxWidth: .infinity)
          .background(Color.secondary.opacity(0.1))
          .cornerRadius(10)
          .padding(.horizontal)
      }
    }
  }

  var questionScreen: some View {
    QuestionScreen(showGame: $showGame, tablesUpTo: tablesUpTo, numberOfQuestions: numberOfQuestions)
      .navigationBarBackButtonHidden()
      .navigationTitle("Questions")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            showGame = false
          } label: {
            Text("New game")
          }
        }
      }
  }
}

struct MainScreen_Previews: PreviewProvider {
  static var previews: some View {
    MainScreen()
  }
}
