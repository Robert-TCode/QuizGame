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

        let localDatabase = PersistenceDatabase()
        let databaseManager = DatabaseManager(persistentDatabase: localDatabase)
 
        // TODO Present a loader initally in navigationController
        // in the compeltion, present the real data
        databaseManager.fetchGameDataSet { (questions, options, correctAnswers) in
            let factory = iOSViewControllerFactory(questions: questions, options: options, correctAnswers: correctAnswers)
            let router = NavigationControllerRouter(navigationController, factory: factory)

            self.game = startGame(questions: questions, router: router, correctAnswers: correctAnswers)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

