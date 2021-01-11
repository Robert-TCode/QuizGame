//  Created by TCode on 10/01/2021.

import UIKit
import XCTest
import QEngine
@testable import QuizGame

class NavigationControllerRouterTests: XCTestCase {

    let factoryStub = ViewControllerFactoryStub()
    let navigationController = NonAnimatedNavigationController()

    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factoryStub)
    }()

    // When a VC is presented/dismissed using an animation, the test can check for the property before the nimation is completed.
    // A solution for this is the NonAnimatedNavigationController which never animates
    // Another one would be RunLoop.current.run(until: Date())
    func test_routeToQuestion_presentsQuestionController() {
        let viewController1 = UIViewController()
        let viewController2 = UIViewController()
        factoryStub.stub(question: Question.singleAnswer("Q1"), with: viewController1)
        factoryStub.stub(question: Question.singleAnswer("Q2"), with: viewController2)
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController1)
        XCTAssertEqual(navigationController.viewControllers.last, viewController2)
    }

    func test_routeToSecondQuestion_presentsQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        let question = Question.singleAnswer("Q1")
        sut.routeTo(question: question, answerCallback: { _ in
            callbackWasFired = true
        })

        factoryStub.answerCallbacks[question]!(["answer"])
        XCTAssertTrue(callbackWasFired)
    }

    // MARK: Helper

    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }

    class ViewControllerFactoryStub: ViewControllerFactory {
        var stubbedQuestions = Dictionary<Question<String>, UIViewController>()
        var answerCallbacks = Dictionary<Question<String>, ([String]) -> Void>()

        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }

        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            // Result initializers are inaccessible because it is in QEngine module
            return UIViewController()
        }

        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
    }
}
