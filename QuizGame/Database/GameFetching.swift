//  Created by TCode on 16/01/2021.

import Foundation
import QEngine

protocol GameFetching {
    // Questions, Options, Correct Answers
    typealias GameDataSet = (questions: [Question<String>], options: [Question<String>: [String]], correctAnswers: [Question<String>: Set<String>])

    func fetchGameDataSet(completion: @escaping (GameDataSet) -> Void)
}
