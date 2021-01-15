//  Created by TCode on 10/01/2021.

import UIKit
import XCTest
import QEngine
@testable import QuizGame

class NavigationControllerRouterTests: XCTestCase {

    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
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
        let singleAnswerQuestion2 = Question.singleAnswer("Q2")

        factoryStub.stub(question: singleAnswerQuestion, with: viewController1)
        factoryStub.stub(question: singleAnswerQuestion2, with: viewController2)
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
        sut.routeTo(question: singleAnswerQuestion2, answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController1)
        XCTAssertEqual(navigationController.viewControllers.last, viewController2)
    }

    func test_routeToSecondQuestion_presentsQuestionControllerWithRightCallback() {
        var callbackWasFired = false

        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in callbackWasFired = true })
        factoryStub.answerCallbacks[singleAnswerQuestion]!(["answer"])
        
        XCTAssertTrue(callbackWasFired)
    }

    func test_routeToQuestion_singleAnswer_answerCallback_jumpToNextQuestion() {
        var callbackWasFired = false

        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in callbackWasFired = true })
        factoryStub.answerCallbacks[singleAnswerQuestion]!(["answer"])

        XCTAssertTrue(callbackWasFired)
    }

    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotJumpToNextQuestion() {
        var callbackWasFired = false

        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackWasFired = true })
        factoryStub.answerCallbacks[multipleAnswerQuestion]!(["answer"])

        XCTAssertFalse(callbackWasFired)
    }

    func test_routeToQuestion_singleeAnswer_configuresViewControllerWithoutSubmitButton() {
        let controller = UIViewController()

        factoryStub.stub(question: singleAnswerQuestion, with: controller)
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })

        XCTAssertNil(controller.navigationItem.rightBarButtonItem)
    }

    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let controller = UIViewController()

        factoryStub.stub(question: multipleAnswerQuestion, with: controller)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })

        XCTAssertNotNil(controller.navigationItem.rightBarButtonItem)
        XCTAssertEqual(controller.navigationItem.rightBarButtonItem?.title, "Submit")
    }

    func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenNoAnswersSelected() {
        let controller = UIViewController()

        factoryStub.stub(question: multipleAnswerQuestion, with: controller)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })

        XCTAssertNotNil(controller.navigationItem.rightBarButtonItem)
        XCTAssertFalse(controller.navigationItem.rightBarButtonItem!.isEnabled)

        factoryStub.answerCallbacks[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(controller.navigationItem.rightBarButtonItem!.isEnabled)

        factoryStub.answerCallbacks[multipleAnswerQuestion]!([])
        XCTAssertFalse(controller.navigationItem.rightBarButtonItem!.isEnabled)
    }

    func test_routeToQuestion_multipleAnswerSubmitButton_activeSelectionAndTapButton_jumpToNextQuestion() {
        let controller = UIViewController()
        var callbackWasFired = false

        factoryStub.stub(question: multipleAnswerQuestion, with: controller)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackWasFired = true})
        factoryStub.answerCallbacks[multipleAnswerQuestion]!(["A1"])

        let button = controller.navigationItem.rightBarButtonItem!
        button.simulateTap()

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
        var answerCallbacks = Dictionary<Question<String>, (Set<String>) -> Void>()

        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }

        func resultViewController(for result: Result<Question<String>, Set<String>>) -> UIViewController {
            // Result initializers are i naccessible because it is in QEngine module
            return UIViewController()
        }

        func questionViewController(for question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) -> UIViewController {
            self.answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
    }
}

// MARK: UIBarButtonItem Extension

private extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
