//
//  Router.swift
//  QuizEngine
//
//  Created by YuriyFpc on 01.12.2022.
//

public protocol Router {
    associatedtype Answer
    associatedtype Question: Hashable

    func routeTo(question: Question, answerCallback: @escaping ([Answer]) -> Void)
    func routeTo(_ result: Result<Question, Answer>)
}
