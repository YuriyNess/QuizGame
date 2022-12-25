//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 11.12.2022.
//

import XCTest
@testable import QuizEngine
@testable import QuizApp

class ResultsPresenterTests: XCTestCase {

    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    func test_title() {
        let sut = ResultsPresenter(result: Result<Question<String>, String>(answers: [:], score: 0), questions: [])

        XCTAssertEqual(sut.title, "Results")
    }

    func test_summary_withTwoQuestionsAndScoreOne_returnsSummary() {
        let result = Result(answers: [
            singleAnswerQuestion: ["A1"],
            multipleAnswerQuestion: ["A3", "A4"]
        ], score: 1)

        let sut = ResultsPresenter(result: result, questions: [
            singleAnswerQuestion, multipleAnswerQuestion
        ])

        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }

    func test_presentableAnswers_withoutQuestionAndResultAnswers_isEmpty() {
        let answers = [Question<String>: [String]]()
        let result = Result(answers: answers, score: 1)
        let correctAnswers = [Question<String>: [String]]()

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: [])

        XCTAssertTrue(sut.presentableAnswers.isEmpty)
    }

    func test_presentableAnswers_withOneCorrectSingleAnswer_mapAnswer() {
        let result = Result(answers: [
            singleAnswerQuestion: ["A1"],
        ], score: 1)
        let correctAnswers = [singleAnswerQuestion: ["A1"]]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: [singleAnswerQuestion])

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }

    func test_presentableAnswers_withOneWrongSingleAnswer_mapAnswer() {
        let result = Result(answers: [
            singleAnswerQuestion: ["A2"],
        ], score: 1)
        let correctAnswers = [singleAnswerQuestion: ["A1"]]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: [singleAnswerQuestion])

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A2")
    }

    func test_presentableAnswers_withOneCorrectMultipleAnswer_mapAnswer() {
        let result = Result(answers: [
            multipleAnswerQuestion: ["A1", "A2"],
        ], score: 0)
        let correctAnswers = [
            multipleAnswerQuestion: ["A1", "A2"]
        ]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: [multipleAnswerQuestion])

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1, A2")
        XCTAssertNil(sut.presentableAnswers.first?.wrongAnswer)
    }

    func test_presentableAnswers_withOneWrongMultipleAnswer_mapAnswer() {
        let result = Result(answers: [
            multipleAnswerQuestion: ["A1", "A2"],
        ], score: 1)
        let correctAnswers = [
            multipleAnswerQuestion: ["A2", "A3"]
        ]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: [multipleAnswerQuestion])

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first?.wrongAnswer, "A1, A2")
    }

    func test_presentableAnswers_withTwoQuestions_mapOrderedAnswer() {
        let result = Result(answers: [
            multipleAnswerQuestion: ["A1", "A2"],
            singleAnswerQuestion: ["A3"]
        ], score: 1)
        let correctAnswers = [
            singleAnswerQuestion: ["A3"],
            multipleAnswerQuestion: ["A1", "A2"],
        ]
        let questions = [
            multipleAnswerQuestion,
            singleAnswerQuestion
        ]

        let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)

        XCTAssertEqual(sut.presentableAnswers.first?.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.first?.answer, "A1, A2")

        XCTAssertEqual(sut.presentableAnswers.last?.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.last?.answer, "A3")
    }
}
