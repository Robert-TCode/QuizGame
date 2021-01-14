//  Created by TCode on 12/01/2021.

import QEngine

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: Dictionary<Question<String>, [String]>

    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }

    var presentableAnswers: [PresentableAnswer] {
        questions.map { question -> PresentableAnswer in
            guard let correctAnswer = correctAnswers[question],
                  let userAnswer = result.answers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }

            return presentableAnswer(question: question, userAnswer: userAnswer, correctAnswer: correctAnswer)
        }
    }

    private func presentableAnswer(question: Question<String>, userAnswer: [String], correctAnswer: [String]) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(question: value,
                                     answer: formattedCorrectAnswer(correctAnswer),
                                     wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer))
        }
    }

    private func formattedCorrectAnswer(_ correctAnswer: [String]) -> String {
        correctAnswer.joined(separator: ", ")
    }

    private func formattedWrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
        userAnswer.containsSameElements(as: correctAnswer) ? nil : userAnswer.joined(separator: ", ")
    }
}
