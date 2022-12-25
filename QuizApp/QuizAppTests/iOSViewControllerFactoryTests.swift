//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 09.12.2022.
//

import XCTest
@testable import QuizApp
@testable import QuizEngine

class iOSViewControllerFactoryTests: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")

    lazy var options: [Question<String>: [String]] = [singleAnswerQuestion: ["A1","A2"], multipleAnswerQuestion: ["A1","A2","A3","A4"]]

    lazy var questions = [
        singleAnswerQuestion,
        multipleAnswerQuestion
    ]

    func test_questionViewController_withSingleAnswerQuestion_createsControllerWithTitle() {
        let presenter = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: questions)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion)?.title, presenter.title)
    }

    func test_questionViewController_withMultipleAnswerQuestion_createsControllerWithTitle() {
        let presenter = QuestionPresenter(currentQuestion: multipleAnswerQuestion, questions: questions)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion)?.title, presenter.title)
    }

    func test_questionViewController_createsQuestionViewControllerWithProperties() {
        var callbackAnswers = [String]()
        let controller = makeQuestionController(
            question: singleAnswerQuestion,
            answers: ["A1", "A2"]) { answers in
            callbackAnswers = answers
        }

        controller?.selection?(["A1", "A2"])

        XCTAssertNotNil(controller)
        XCTAssertEqual(controller?.question, "Q1")
        XCTAssertEqual(controller?.options, ["A1", "A2"])
        XCTAssertEqual(callbackAnswers, ["A1", "A2"])
    }

    func test_questionViewControllerWithSingleAnswer_createsQuestionViewControllerWithSingleAnswer() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion)!.allowsMultipleSelection)
    }

    func test_questionViewControllerWithMultipleAnswer_createsQuestionViewControllerWithMultipleAnswer() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion)!.allowsMultipleSelection)
    }

    func test_resultViewController_createsWithCorrectProperties() {
        let userAnswers = [
            singleAnswerQuestion: ["A1"],
            multipleAnswerQuestion: ["A2", "A3"]
        ]
        let correctAnswers = [
            singleAnswerQuestion: ["A1"],
            multipleAnswerQuestion: ["A2", "A3"]
        ]

        let result = Result(answers: userAnswers, score: 2)
        let resultPresenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)

        let sut = makeSUT(correctAnswers: correctAnswers)
        let controller = sut.resultViewController(for: result) as? ResultsViewController

        XCTAssertNotNil(controller)
        XCTAssertEqual(controller!.title, resultPresenter.title)
        XCTAssertEqual(controller!.summary, resultPresenter.summary)
        XCTAssertEqual(controller!.answers.count, resultPresenter.presentableAnswers.count)
    }

    // MARK: - Helpers
    private func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        iOSViewControllerFactory(questions: questions, options: options, correctAnswers: correctAnswers)
    }

    private func makeResultsController(options: [Question<String>: [String]] = [:], result: Result<Question<String>, String>, correctAnswers: [Question<String>: [String]] = [:]) -> ResultsViewController? {
        makeSUT(options: options, correctAnswers: correctAnswers)
            .resultViewController(for: result) as? ResultsViewController
    }

    private func makeQuestionController(question: Question<String>, answers: [String] = [], answerCallback: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController? {
        let controller = makeSUT(options: [question: options[question] ?? []])
            .questionViewController(for: question, answerCallback: answerCallback)
        return controller as? QuestionViewController
    }
}
