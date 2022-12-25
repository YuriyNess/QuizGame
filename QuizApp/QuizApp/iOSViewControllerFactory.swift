//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by YuriyFpc on 09.12.2022.
//

import UIKit
import QuizEngine

final class iOSViewControllerFactory: ViewControllerFactory {
    let options: [Question<String>: [String]]
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]

    init(questions: [Question<String>], options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }

    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Cant find options for question: \(question)")
        }
        switch question {
        case .singleAnswer(let value):
            let controller = questionController(for: question, value: value, options: options, answerCallback: answerCallback)
            return controller
        case .multipleAnswer(let value):
            let controller = questionController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
            return controller
        }
    }

    private func questionController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool = false, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(currentQuestion: question, questions: questions)
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }

    func resultViewController(for result: Result<Question<String>, String>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)
        let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller
    }
}
