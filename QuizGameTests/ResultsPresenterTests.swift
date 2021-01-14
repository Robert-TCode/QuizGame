//  Created by TCode on 12/01/2021.

import XCTest
import QEngine
@testable import QuizGame

class ResultsPresenterTests: XCTestCase {

    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func test_title_returnsFormatterTitle() {
        let result: Result<Question<String>, [String]> = Result(answers: [:], score: 1)
        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])

        XCTAssertEqual(sut.title, "Results")
    }

    func test_withTwoQuestionsAndScoreOne_returnsSummary() {
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: [singleAnswerQuestion: ["A1"], Question.multipleAnswer("Q1"): ["A2", "A3"]], score: 1)

        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: [:])

        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }

    func test_withThreeQuestionsAndScoreTwo_returnsSummary() {
        let result = Result(answers: [singleAnswerQuestion: ["A1"],
                                      multipleAnswerQuestion: ["A2", "A3"],
                                      Question.singleAnswer("Q3"): ["A4"]], score: 2)

        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion, multipleAnswerQuestion, Question.singleAnswer("Q3")], correctAnswers: [:])

        XCTAssertEqual(sut.summary, "You got 2/3 correct")
    }

    func test_presentableAnswers_withoutQuestion_isEmpty() {
        let answers = Dictionary<Question<String>, [String]>()
        let result = Result(answers: answers, score: 2)

        let sut = ResultsPresenter(result: result, questions: [], correctAnswers: [:])

        XCTAssertEqual(sut.presentableAnswers.count, 0)
    }

    func test_presentableAnswers_withoutWrongSingleAnswer_mapsAnswer() {
        let result = Result(answers: [singleAnswerQuestion: ["A1"]], score: 0)
        let correctAnswers = [singleAnswerQuestion: ["A2"]]

        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1")
    }

    func test_presentableAnswers_withoutWrongMultipleAnswer_mapsAnswer() {
        let result = Result(answers: [singleAnswerQuestion: ["A1", "A2"]], score: 0)
        let correctAnswers = [singleAnswerQuestion: ["A3", "A4"]]

        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A3, A4")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1, A2")
    }

    func test_presentableAnswers_withoutRightSingleAnswer_mapsAnswer() {
        let result = Result(answers: [Question.singleAnswer("Q1"): ["A1"]], score: 1)
        let correctAnswers = [Question.singleAnswer("Q1"): ["A1"]]
        let sut = ResultsPresenter(result: result, questions: [Question.singleAnswer("Q1")], correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer )
    }

    func test_presentableAnswers_withoutRightMultipleAnswer_mapsAnswer() {
        let result = Result(answers: [singleAnswerQuestion: ["A1", "A2"]], score: 1 )
        let correctAnswers = [singleAnswerQuestion: ["A1", "A2"]]

        let sut = ResultsPresenter(result: result, questions: [singleAnswerQuestion], correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1, A2")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }

    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {
        let answers = [multipleAnswerQuestion: ["A1", "A2"], singleAnswerQuestion: ["A4"]]
        let orderedQuestions = [singleAnswerQuestion, multipleAnswerQuestion]
        let correctAnswers = [multipleAnswerQuestion: ["A1", "A2"], singleAnswerQuestion: ["A4"]]
        let result = Result(answers: answers, score: 1 )

        let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)

        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A4")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last?.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last?.answer, "A1, A2")
        XCTAssertNil(sut.presentableAnswers.last?.wrongAnswer)
    }
}
