//  Created by TCode on 13/01/2021.

import QEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let currentQuestion: Question<String>

    var title: String {
        guard let index = questions.firstIndex(of: currentQuestion) else {
            fatalError("Cannot find question \(currentQuestion) in array \(questions)")
        }

        let stringIndex = String(describing: (index + 1))
        return "Question #\(stringIndex)"
    }
}
