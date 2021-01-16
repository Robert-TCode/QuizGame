//  Created by TCode on 12/01/2021.

import QEngine

struct ResultsPresenter {
    let result: Result<Question<String>, Set<String>>
    let questions: [Question<String>]
    let correctAnswers: Dictionary<Question<String>, Set<String>>

    var title: String {
        "Results"
    }

    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }

    var presentableAnswers: [PresentableAnswer] {
        questions.map { question -> PresentableAnswer in
            guard let correctAnswer = correctAnswers[question],
                  let userAnswer = result.answers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }

            return presentableAnswer(question, userAnswer, correctAnswer )
        }
    }

    private func presentableAnswer(_ question: Question<String>, _ userAnswer: Set<String>, _ correctAnswer: Set<String>) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(question: value,
                                     answer: formattedCorrectAnswer(correctAnswer),
                                     wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
        }
    }

    private func formattedCorrectAnswer(_ correctAnswer: Set<String>) -> String {
        correctAnswer.sorted().joined(separator: ", ")
    }

    private func formattedWrongAnswer(_ userAnswer: Set<String>, _ correctAnswer: Set<String>) -> String? {
        userAnswer == correctAnswer ? nil : userAnswer.sorted().joined(separator: ", ")
    }
}
