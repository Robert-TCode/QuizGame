//  Created by TCode on 30/12/2020.

import XCTest
@testable import QuizGame

class ResultsViewControllerTests: XCTestCase {

    func test_viewDidLoad_renderSummary() {
        let sut = makeSUT(summary: "a summary")
        XCTAssertEqual(sut.headerLabel.text, "a summary")
    }

    func test_viewDidLoad_renderAsnwers() {
        XCTAssertEqual(makeSUT().tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer(), makeAnswer()]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_withCorrectAnswer_renderCorrectAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer()])
        XCTAssertNotNil(sut.tableView.cell(at: 0) as? CorrectAnswerCell)
    }

    func test_viewDidLoad_withWrongAnswer_renderWrongAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(wrongAnswer: "")])
        XCTAssertNotNil(sut.tableView.cell(at: 0) as? WrongAnswerCell)
    }

    func test_viewDidLoad_withCorrectAnswer_configureCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1")])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }

    func test_viewDidLoad_withWrongAnswer_configureCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "wrong")])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "wrong")
    }

    // MARK: Helpers

    private func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        return ResultsViewController(summary: summary, answers: answers)
    }

    private func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }

}
