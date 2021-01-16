//  Created by TCode on 16/01/2021.

import Foundation
import QEngine

class PersistenceDatabase: GameFetching {
    private var questions: [Question<String>] = []
    private var options: [Question<String> : [String]] = [:]
    private var correctAnswers: [Question<String> : Set<String>] = [:]

    init() {
        populateWithDummyData()
    }

    func fetchGameDataSet(completion: @escaping (GameFetching.GameDataSet) -> Void) {
        completion((questions, options, correctAnswers))
    }

    // MARK: Update

    func clearDatabase() {
        self.questions.removeAll()
        self.options.removeAll()
        self.correctAnswers.removeAll()
    }

    func updateQuestions(_ gameDataSet: GameFetching.GameDataSet) {
        clearDatabase()
        self.questions = gameDataSet.questions
        self.options = gameDataSet.options
        self.correctAnswers = gameDataSet.correctAnswers
    }

    func addQuestion(_ question: Question<String>, options: [String], correctAnswers: Set<String>) {
        self.questions.append(question)
        self.options[question] = options
        self.correctAnswers[question] = correctAnswers
    }

    // MARK: Helpers

    private func populateWithDummyData() {
        let question1 = Question.singleAnswer("Who said \"Winter is coming\" for the first time in Game of Thrones?")
        let option1 = "Maester Luwin"
        let option2 = "John Snow"
        let option3 = "Robb Stark"
        let option4 = "Eddard Stark"

        let question2 = Question.multipleAnswer("Who went beyond the Wall in Game of Thrones?")
        let option5 = "Randyll Tarly"
        let option6 = "Tyrion Lannister"
        let option7 = "Meera Reed"
        let option8 = "Jorah Mormont"

        questions = [question1, question2]
        options = [question1: [option1, option2, option3, option4],
                                    question2: [option5, option6, option7, option8]]
        correctAnswers = [question1: [option4], question2: [option7, option8]]
    }
}
