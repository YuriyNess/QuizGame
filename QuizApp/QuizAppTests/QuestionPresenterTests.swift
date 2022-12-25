//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 13.12.2022.
//

import XCTest
import QuizEngine
@testable import QuizApp

class QuestionPresenterTests: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func test_title_emptyQuestions_emptyTitle() {
        let sut = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: [])
        XCTAssertEqual(sut.title, "")
    }

    func test_title_firstQuestion_formattedQuestion() {
        let sut = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
        XCTAssertEqual(sut.title, "Question 1")
    }

    func test_title_secondQuestion_formattedQuestion() {
        let sut = QuestionPresenter(currentQuestion: multipleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
        XCTAssertEqual(sut.title, "Question 2")
    }
}
