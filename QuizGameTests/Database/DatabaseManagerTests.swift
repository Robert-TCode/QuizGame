//  Created by TCode on 16/01/2021.

import XCTest
import QEngine
@testable import QuizGame

class DatabaseManagerTests: XCTestCase {

    func test_persistenceDatabase_returnsPersistentData() {
        let persistentDatabase = PersistenceDatabase()
        let sut = DatabaseManager(persistentDatabase: persistentDatabase)

        var gameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            gameDataSet = gameDataSetResult
        }

        XCTAssertFalse(gameDataSet.questions.isEmpty)
        XCTAssertFalse(gameDataSet.options.isEmpty)
        XCTAssertFalse(gameDataSet.correctAnswers.isEmpty)
    }

    func test_remoteDatabase_returnsEmptyData() {
        let persistentDatabase = PersistenceDatabase()
        let sut = DatabaseManager(persistentDatabase: persistentDatabase, useRemoteDatabase: true)

        var gameDataSet: GameFetching.GameDataSet = ([], [:], [:])
        sut.fetchGameDataSet { gameDataSetResult in
            gameDataSet = gameDataSetResult
        }

        XCTAssertTrue(gameDataSet.questions.isEmpty)
        XCTAssertTrue(gameDataSet.options.isEmpty)
        XCTAssertTrue(gameDataSet.correctAnswers.isEmpty)
    }
}
