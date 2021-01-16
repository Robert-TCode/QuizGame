//  Created by TCode on 13/01/2021.

import XCTest
import QEngine
@testable import QuizGame

class QuestionPresenterTests: XCTestCase {

    func test_title_forFirstQuestion_formatesTitleForIndex() {
        let question = Question.singleAnswer("Q1")
        let sut = QuestionPresenter(questions: [question], currentQuestion: question)

        XCTAssertEqual(sut.title, "Question #1")
    }

    func test_title_forSecondQuestion_formatesTitleForIndex() {
        let question1 = Question.singleAnswer("Q1")
        let question2 = Question.singleAnswer("Q2")
        let sut = QuestionPresenter(questions: [question1, question2], currentQuestion: question2)

        XCTAssertEqual(sut.title, "Question #2")
    }
}
