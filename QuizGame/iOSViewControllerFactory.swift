//  Created by TCode on 11/01/2021.

import UIKit
import QEngine

class iOSViewControllerFactory: ViewControllerFactory {

    private let options: Dictionary<Question<String>, [String]>

    init(options: [Question<String>: [String]]) {
        self.options = options
    }

    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options[question] ?? [], selection: answerCallback)
//        case.multipleAnswer(let value): TODO
         default: return UIViewController()
        }
    }

    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
}
