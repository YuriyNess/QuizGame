//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by YuriyFpc on 30.11.2022.
//

import Foundation
import QuizEngine

class RouterSpy: Router {
    typealias Answer = String
    typealias Question = String

    var questions = [String]()
    var result: Result<String, String>?
    var answerCallBack: (([String]) -> Void) = { _ in }

    func routeTo(question: String, answerCallback: @escaping ([String]) -> Void) {
        questions.append(question)
        self.answerCallBack = answerCallback
    }
//
//    func routeTo(question: String, answerCallBack: @escaping ([String]) -> Void) {
//        questions.append(question)
//        self.answerCallBack = answerCallBack
//    }

    func routeTo(_ result: Result<String, String>) {
        self.result = result
    }
}
