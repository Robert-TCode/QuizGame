//  Created by TCode on 11/01/2021.

import UIKit
import XCTest
import QEngine
@testable import QuizGame

class iOSViewControllerFactoryTests: XCTestCase {

    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    let options = ["A1", "A2"]

    // Single

    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], currentQuestion: singleAnswerQuestion)

        XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).title, presenter.title)
    }

    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).question, "Q1")
    }

    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).options, options)
    }

    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionViewController(question: singleAnswerQuestion)
        _ = controller.view

        XCTAssertEqual(controller.isMultipleSelection, false)
    }

    // Multiple

    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], currentQuestion: multipleAnswerQuestion)

        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).title, presenter.title)
    }

    func test_questionViewController_multipleAnswer_createsControllerwithQuestion() {
        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).question, "Q2")
    }

    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).options, options)
    }

    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionViewController(question: multipleAnswerQuestion)
        _ = controller.view

        XCTAssertEqual(controller.isMultipleSelection, true)
    }

    func test_resultsViewController_createsControllerWithSummary() {
        let results = makeResults()

        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }

    func test_resultsViewController_createsControllerWithPresentableAnswers() {
        let results = makeResults()

        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
     
    // MARK: Helpers

    private func makeSUT(options: Dictionary<Question<String>, [String]> = [:], correctAnswers: Dictionary<Question<String>, [String]> = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }

    private func makeQuestionViewController(question: Question<String> = Question.singleAnswer(""), correctAnswers: Dictionary<Question<String>, [String]> = [:]) -> QuestionViewController {
        return makeSUT(options: [question: options], correctAnswers: correctAnswers).questionViewController(for: question) { _ in } as! QuestionViewController
    }

    private func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]

        let sut = makeSUT(correctAnswers: correctAnswers)
        let result = Result(answers: userAnswers, score: 2)

        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let controller = sut.resultViewController(for: result) as! ResultsViewController

        return (controller, presenter)
    }
}
