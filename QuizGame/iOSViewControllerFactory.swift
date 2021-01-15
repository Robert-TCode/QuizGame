//  Created by TCode on 11/01/2021.

import UIKit
import QEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let questions: [Question<String>]
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Dictionary<Question<String>, Set<String>>

    init(questions: [Question<String>], options: Dictionary<Question<String>, [String]>, correctAnswers: Dictionary<Question<String>, Set<String>>) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }

    func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        return questionViewController(for: question, answerCallback: answerCallback, options: options)
    }

    private func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void, options: [String]) -> UIViewController {
        
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, isMultipleSelection: false, answerCallback: answerCallback, options: options)

        case .multipleAnswer(let value):
            let controller = questionViewController(for: question, value: value, isMultipleSelection: true, answerCallback: answerCallback, options: options)
            controller.tableView.allowsMultipleSelection = true

            return controller
        }
    }

    private func questionViewController(for question: Question<String>, value: String, isMultipleSelection: Bool, answerCallback: @escaping (Set<String>) -> Void, options: [String]) -> QuestionViewController {
        let preseter = QuestionPresenter(questions: questions, currentQuestion: question)
        let controller = QuestionViewController(question: value, options: options, isMultipleSelection: isMultipleSelection, selection: { answerCallback(Set($0)) })
        controller.title = preseter.title
        return controller
    }

    func resultViewController(for result: Result<Question<String>, Set<String>>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller 
    }
}
