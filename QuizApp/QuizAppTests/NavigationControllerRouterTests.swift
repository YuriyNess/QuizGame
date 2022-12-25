//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 02.12.2022.
//

import XCTest
import UIKit
@testable import QuizApp
@testable import QuizEngine


class NavigationControllerRouterTests: XCTestCase {
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()

    let singleAnswerQuestionOne = Question.singleAnswer("Q1")
    let singleAnswerQuestionTwo = Question.singleAnswer("Q2")
    let multipleAnswerQuestionOne = Question.multipleAnswer("Q1")
    let multipleAnswerQuestionTwo = Question.multipleAnswer("Q2")

    lazy var sut: NavigationControllerRouter = { NavigationControllerRouter(navigationController: navigationController, factory: factory)
    }()

    func test_routeToQuestion_presentsQuestionController() {
        sut.routeTo(question: singleAnswerQuestionOne, answerCallback: { _ in})

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    // MARK: - SingleAnswer
    func test_routeToQuestionTwice_singleAnswers_presentsCorrectControllers() {
        let firstController = UIViewController()
        let secondController = UIViewController()
        factory.stub(question: singleAnswerQuestionOne, with: firstController)
        factory.stub(question: singleAnswerQuestionTwo, with: secondController)

        sut.routeTo(question: singleAnswerQuestionOne, answerCallback: { _ in })
        sut.routeTo(question: singleAnswerQuestionTwo, answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstController)
        XCTAssertEqual(navigationController.viewControllers.last, secondController)
    }

    func test_routeToQuestion_singleAnswer_makeOneAnswer_invokesCallbackWithCorrectAnswer() {
        let firstController = UIViewController()
        factory.stub(question: singleAnswerQuestionOne, with: firstController)

        var isCallbackInvoked = false
        var callBackValue = [""]
        sut.routeTo(question: singleAnswerQuestionOne, answerCallback: { value in
            isCallbackInvoked = true
            callBackValue = value
        })
        factory.stubbedCallbacks[singleAnswerQuestionOne]!(["some answer"])

        XCTAssertTrue(isCallbackInvoked)
        XCTAssertEqual(callBackValue, ["some answer"])
    }

    func test_routeToQuestion_singleAnswer_configureControllerWithoutSubmitButton() {
        let firstController = UIViewController()
        factory.stub(question: singleAnswerQuestionOne, with: firstController)

        sut.routeTo(question: singleAnswerQuestionOne, answerCallback: { _ in })

        XCTAssertNil(navigationController.navigationItem.rightBarButtonItem)
    }

    // MARK: - MultipleAnswer
    func test_routeToQuestion_multipleAnswer_makeOneAnswer_doesNotInvokeCallback() {
        let firstController = UIViewController()
        factory.stub(question: multipleAnswerQuestionOne, with: firstController)

        var isCallbackInvoked = false
        sut.routeTo(question: multipleAnswerQuestionOne, answerCallback: { value in
            isCallbackInvoked = true
        })

        factory.stubbedCallbacks[multipleAnswerQuestionOne]!(["some answer"])
        XCTAssertFalse(isCallbackInvoked)

        let button = firstController.navigationItem.rightBarButtonItem!
        button.target!.performSelector(onMainThread: button.action!, with: nil, waitUntilDone: true)

        XCTAssertTrue(isCallbackInvoked)
    }

    func test_routeToQuestion_multipleAnswer_configureControllerWithSubmitButton() {
        let firstController = UIViewController()
        factory.stub(question: multipleAnswerQuestionOne, with: firstController)

        sut.routeTo(question: multipleAnswerQuestionOne, answerCallback: { _ in })

        XCTAssertNotNil(firstController.navigationItem.rightBarButtonItem)
    }

    func test_routeToQuestion_multipleAnswerSubmitButton_disabledWhenZeroAnswersSelected() {
        let firstController = UIViewController()
        factory.stub(question: multipleAnswerQuestionOne, with: firstController)

        sut.routeTo(question: multipleAnswerQuestionOne, answerCallback: { _ in })
        factory.stubbedCallbacks[multipleAnswerQuestionOne]!([])

        XCTAssertFalse(firstController.navigationItem.rightBarButtonItem!.isEnabled)
    }

    func test_routeToQuestion_multipleAnswerSubmitButton_stateChanges() {
        let firstController = UIViewController()
        factory.stub(question: multipleAnswerQuestionOne, with: firstController)

        sut.routeTo(question: multipleAnswerQuestionOne, answerCallback: { _ in })

        XCTAssertFalse(firstController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.stubbedCallbacks[multipleAnswerQuestionOne]!(["A1"])

        XCTAssertTrue(firstController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.stubbedCallbacks[multipleAnswerQuestionOne]!([])

        XCTAssertFalse(firstController.navigationItem.rightBarButtonItem!.isEnabled)
    }

    // MARK: - Result
    func test_routeToResultTwice_presentsCorrectControllers() {
        let firstController = UIViewController()
        let secondController = UIViewController()
        let result = Result(answers: [singleAnswerQuestionOne: ["A1"]], score: 10)
        let result2 = Result(answers: [singleAnswerQuestionTwo: ["A2"]], score: 20)
        factory.stub(result: result, with: firstController)
        factory.stub(result: result2, with: secondController)

        sut.routeTo(result)
        sut.routeTo(result2)

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstController)
        XCTAssertEqual(navigationController.viewControllers.last, secondController)
    }

    // MARK: - Helpers
    final class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }

    final class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [Result<Question<String>, String>: UIViewController]()
        var stubbedCallbacks = [Question<String>: ([String]) -> Void]()

        func stub(question: Question<String>, with controller: UIViewController) {
            stubbedQuestions[question] = controller
        }

        func stub(result: Result<Question<String>, String>, with controller: UIViewController) {
            stubbedResults[result] = controller
        }

        func questionViewController(for question: Question<String>, answerCallback answerCallBack: @escaping ([String]) -> Void) -> UIViewController {
            stubbedCallbacks[question] = answerCallBack
            return stubbedQuestions[question] ?? UIViewController()
        }

        func resultViewController(for result: Result<Question<String>, String>) -> UIViewController {
            stubbedResults[result] ?? UIViewController()
        }
    }
}

extension Result: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }

    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        lhs.score == rhs.score
    }
}
