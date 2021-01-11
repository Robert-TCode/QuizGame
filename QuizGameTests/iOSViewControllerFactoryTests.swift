//  Created by TCode on 11/01/2021.

import XCTest
@testable import QuizGame

class iOSViewControllerFactoryTests: XCTestCase {

    func test_questionViewController_createsControllerwithQuestion() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        let controller = sut.questionViewController(for: Question.singleAnswer("Q1")) { _ in } as? QuestionViewController

        XCTAssertEqual(controller?.question, "Q1")
    }

    func test_questionViewController_createsControllerWithOptions() {
        let question = Question.singleAnswer("1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        let controller = sut.questionViewController(for: Question.singleAnswer("1")) { _ in } as! QuestionViewController
        XCTAssertEqual(controller.options, options)
    }
}
