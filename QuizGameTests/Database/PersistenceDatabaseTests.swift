//  Created by TCode on 16/01/2021.

import Foundation
import XCTest
import QEngine
@testable import QuizGame

class PersistenceDatabaseTests: XCTestCase {

    func test_initatesWithDummyData() {
        let sut = PersistenceDatabase()
        var gameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            gameDataSet = gameDataSetResult
        }

        XCTAssertFalse(gameDataSet.questions.isEmpty)
        XCTAssertFalse(gameDataSet.options.isEmpty)
        XCTAssertFalse(gameDataSet.correctAnswers.isEmpty)
    }

    func test_updateQuestions() {
        let sut = PersistenceDatabase()

        let question1 = Question.singleAnswer("Q3")
        let question2 = Question.multipleAnswer("Q4")

        let options1 = ["A3", "A4", "A5"]
        let options2 = ["A6", "A7", "A8", "A9"]

        let correctAnswers1 = ["A5"]
        let correctAnswers2 = ["A8", "A9"]

        let newGameSet: GameFetching.GameDataSet = ([question1, question2],
                                                    [question1: options1, question2: options2],
                                                    [question1: Set(correctAnswers1), question2: Set(correctAnswers2)])
        sut.updateQuestions(newGameSet)

        var fetchedGameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            fetchedGameDataSet = gameDataSetResult
        }

        XCTAssertEqual(fetchedGameDataSet.questions, [question1, question2])
        XCTAssertEqual(fetchedGameDataSet.options[question1], options1)
        XCTAssertEqual(fetchedGameDataSet.options[question2], options2)
        XCTAssertEqual(fetchedGameDataSet.correctAnswers[question1], Set(correctAnswers1))
        XCTAssertEqual(fetchedGameDataSet.correctAnswers[question2], Set(correctAnswers2))
    }

    func test_addQuestions() {
        let sut = PersistenceDatabase()

        let question1 = Question.singleAnswer("Q3")
        let options1 = ["A3", "A4", "A5"]
        let correctAnswers1 = ["A5"]

        sut.addQuestion(question1, options: options1, correctAnswers: Set(correctAnswers1))

        var fetchedGameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            fetchedGameDataSet = gameDataSetResult
        }

        XCTAssertTrue(fetchedGameDataSet.questions.contains(question1))
        XCTAssertEqual(fetchedGameDataSet.options[question1], options1)
        XCTAssertEqual(fetchedGameDataSet.correctAnswers[question1], Set(correctAnswers1))
    }

    func test_clearDatabase() {
        let sut = PersistenceDatabase()
        sut.clearDatabase()

        var gameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            gameDataSet = gameDataSetResult
        }

        XCTAssertTrue(gameDataSet.questions.isEmpty)
        XCTAssertTrue(gameDataSet.options.isEmpty)
        XCTAssertTrue(gameDataSet.correctAnswers.isEmpty)
    }
}
