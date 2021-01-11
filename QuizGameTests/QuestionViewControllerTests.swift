//  Created by TCode on 30/12/2020.

import XCTest
@testable import QuizGame

class QuestionViewControllerTests: XCTestCase {

    func test_viewDidLoad_renderQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }

    func test_viewDidLoad_renderOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["Option 1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["Option 1", "Option 2"]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_textForOptions() {
        XCTAssertEqual(makeSUT(options: ["Option 1"]).tableView.title(at: 0), "Option 1")
        XCTAssertEqual(makeSUT(options: ["Option 1", "Option 2"]).tableView.title(at: 1), "Option 2")
    }

    func test_singleSelection_notifiesDelegateWhenSelectionChanges() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1", "A2"]) {
            receivedAnswer = $0
        }

        sut.tableView.selectRow(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.selectRow(at: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }

    func test_singleSelection_doesNotNotifiesDelegateWithEmptySelection() {
        var callBackCount = 0
        let sut = makeSUT(options: ["A1", "A2"]) { _ in
            callBackCount += 1
        }

        sut.tableView.selectRow(at: 0)
        XCTAssertEqual(callBackCount, 1)

        sut.tableView.deselectRow(at: 0)
        XCTAssertEqual(callBackCount, 1)
    }

    func test_multipleSelection_notifiesDelegateSelection() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1", "A2"]) {
            receivedAnswer = $0
        }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.selectRow(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.selectRow(at: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }

    func test_multipleSelectionsEnabled_notifiesDelegateDeselection() {
        var receivedAnswer = [""]
        let sut = makeSUT(options: ["A1", "A2"]) {
            receivedAnswer = $0
        }
        sut.tableView.allowsMultipleSelection = true

        sut.tableView.selectRow(at: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.deselectRow(at: 0)
        XCTAssertEqual(receivedAnswer, [])
    }

    // MARK: Helper

    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping ([String]) -> Void = {_ in }) -> QuestionViewController {
        // This is an example of integration testing, where we are using the Factory to create the QuestionViewController
        // The disadvantage of this approach is that we could need to have check and implement multiple factories in the future
        // The advantage is that we're testing the integration of the system at the same time

//        let questionType = Question.singleAnswer(question)
//        let factory = iOSViewControllerFactory(options: [questionType: options])
//        return factory.questionViewController(for: questionType, answerCallback: selection) as! QuestionViewController

        // This is an example of the unit tests, where we are using directly the object we will be testing
        // The advantage of this is that it has single responsibility and keeps the tests for each factory separated, outside of this file
        return QuestionViewController(question: question, options: options, selection: selection)
    }
}
