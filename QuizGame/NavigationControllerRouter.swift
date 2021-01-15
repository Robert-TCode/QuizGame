//  Created by TCode on 10/01/2021.

import UIKit
import QEngine

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory

    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: Question<String>, answerCallback: @escaping (Set<String>) -> Void) {
        switch question {
        case .singleAnswer(_):
            show(factory.questionViewController(for: question, answerCallback: answerCallback))
        case .multipleAnswer(_):
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button, answerCallback)
            let controller = factory.questionViewController(for: question) { selection in
                buttonController.update(selection)
            }

            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    
    func routeTo(result: Result<Question<String>, Set<String>>) {
        show(factory.resultViewController(for: result))
    }

    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController: NSObject {
    let button: UIBarButtonItem
    let callback: (Set<String>) -> Void
    private var model: Set<String> = []

    init(_ button: UIBarButtonItem, _ callback: @escaping (Set<String>) -> Void) {
        self.button = button
        self.callback = callback
        super.init()

        self.setup()
    }

    private func setup() {
        button.target = self
        button.action = #selector(fireCallback(_:))
        updateButtonState()
    }

    func update(_ model: Set<String>) {
        self.model = model
        updateButtonState()
    }

    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }

    @objc func fireCallback(_ sender: Any?) {
        callback(model)
    }
}
