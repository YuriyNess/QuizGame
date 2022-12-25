//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by YuriyFpc on 11.12.2022.
//

import QuizEngine

struct ResultsPresenter {
    let result: Result<Question<String>, String>
    var correctAnswers: [Question<String>: [String]] = [:]
    let questions: [Question<String>]

    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }

    let title = "Results"

    var presentableAnswers: [PresentableAnswer] {
        questions.map { question in
            guard let answer = result.answers[question], let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn`t find correct answer for question: \(question)")
            }
            let wrongAnswer = correctAnswer == answer ? nil : answer

            switch question {
            case .singleAnswer(let value), .multipleAnswer(let value):
                return PresentableAnswer(question: value, answer: correctAnswer.joined(separator: ", "), wrongAnswer: wrongAnswer?.joined(separator: ", "))
            }
        }
    }
}
