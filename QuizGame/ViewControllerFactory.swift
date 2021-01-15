//  Created by TCode on 11/01/2021.

import UIKit
import QEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, Set<String>>) -> UIViewController
}
