//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by YuriyFpc on 26.11.2022.
//

import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var game: Game<Question<String>, String, NavigationControllerRouter>?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let question1 = Question.singleAnswer("What is Cuban national dance?")
        let question2 = Question.multipleAnswer("What are Angola national dances?")

        let questions = [
            question1,
            question2
        ]
        let options = [
            question1: ["Salsa", "Bachata", "Tango"],
            question2: ["Kizomba", "Semba", "Coduro"]
        ]

        let correctAnswers = [
            question1: ["Salsa"],
            question2: ["Kizomba", "Semba"]
        ]

        let nc = UINavigationController()
//        nc.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Submit", style: .plain, target: nil, action: nil)]
        let factory = iOSViewControllerFactory(
            questions: questions,
            options: options,
            correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(
            navigationController: nc,
            factory: factory
        )

        game = startingGame(questions: questions, router: router, correctAnswers: correctAnswers)

        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }
}

