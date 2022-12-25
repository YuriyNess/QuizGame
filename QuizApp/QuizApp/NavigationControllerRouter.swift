//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by YuriyFpc on 02.12.2022.
//

import Foundation
import QuizEngine
import UIKit

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultViewController(for result: Result<Question<String>, String>) -> UIViewController
}

final class NavigationControllerRouter: Router {

    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory

    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: answerCallback))
        case .multipleAnswer:
            let barButtonController = SubmitButtonController(
                UIBarButtonItem(title: "Submit", style: .plain, target: nil, action: nil)
                , answerCallback
            )

            let controller = factory.questionViewController(for: question, answerCallback: { selection in
                barButtonController.update(selection)
            })
            controller.navigationItem.rightBarButtonItem = barButtonController.barButton

            show(controller)
        }
    }

    func routeTo(_ result: Result<Question<String>, String>) {
        show(factory.resultViewController(for: result))
    }

    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

class SubmitButtonController: NSObject {
    let barButton: UIBarButtonItem
    let callBack: ([String]) -> Void
    private var model: [String] = []

    init(_ barButton: UIBarButtonItem, _ callBack: @escaping ([String]) -> Void) {
        self.barButton = barButton
        self.callBack = callBack
        super.init()

        setup()
    }

    private func setup() {
        barButton.target = self
        barButton.action = #selector(fireCallback)
        barButton.isEnabled = false
    }

    func update(_ model: [String]) {
        self.model = model
        updateButton()
    }

    private func updateButton() {
        barButton.isEnabled = model.count > 0
    }

    @objc
    private func fireCallback() {
        callBack(model)
    }
}
