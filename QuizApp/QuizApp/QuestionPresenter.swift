//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by YuriyFpc on 13.12.2022.
//

import QuizEngine

struct QuestionPresenter {
    let currentQuestion: Question<String>
    let questions: [Question<String>]

    var title: String {
        guard let questionIndex = questions.firstIndex(of: currentQuestion) else { return "" }
        return "Question \(questionIndex + 1)"
    }
}
