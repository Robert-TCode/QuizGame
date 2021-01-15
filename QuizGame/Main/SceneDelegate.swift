//  Created by TCode on 30/12/2020.

import UIKit
import QEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var game: Game<Question<String>, Set<String>, NavigationControllerRouter>?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationController = UINavigationController()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let database = createData()
        let factory = iOSViewControllerFactory(questions: database.questions, options: database.options, correctAnswers: database.correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)

        game = startGame(questions: database.questions, router: router, correctAnswers: database.correctAnswers)
    }

    private func createData() -> (questions: [Question<String>], options: [Question<String>: [String]], correctAnswers: [Question<String>: Set<String>]) {
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

        let questions = [question1, question2]
        let options: [Question<String>: [String]] = [question1: [option1, option2, option3, option4],
                                    question2: [option5, option6, option7, option8]]
        let correctAnswers: [Question<String>: Set<String>] = [question1: [option4], question2: [option7, option8]]

        return (questions, options, correctAnswers)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

