//
//  ResultsViewController.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 28.11.2022.
//

import XCTest
@testable import QuizApp

class ResultsViewControllerTests: XCTestCase {

    func test_viewDidLoad_tableViewDataSourceNotNil() {
        XCTAssertNotNil(makeSUT().tableView.dataSource)
    }

    func test_viewDidLoad_tableViewDelegateNotNil() {
        XCTAssertNotNil(makeSUT().tableView.delegate)
    }

    func test_viewDidLoad_renderHeaderLabel() {
        XCTAssertEqual(makeSUT(summary: "Summary").headerLabel.text, "Summary")
    }

    func test_viewDidLoad_rendersResults() {
        XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(answers: [makeAnswer(), makeAnswer()]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_withCorrectAnswer_rendersCorrectAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer()])

        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell)
    }

    func test_viewDidLoad_withCorrectAnswer_configureCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1")])

        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell)

        XCTAssertNotNil(cell?.questionLabel.text)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")

        XCTAssertNotNil(cell?.answerLabel.text)
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }

    func test_viewDidLoad_withWrongAnswer_configureCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "W1")])

        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell)

        XCTAssertNotNil(cell?.questionLabel.text)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")

        XCTAssertNotNil(cell?.correctAnswerLabel.text)
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")

        XCTAssertNotNil(cell?.wrongAnswerLabel.text)
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "W1")
    }

    // MARK: - Helpers
    func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        let _ = sut.view
        return sut
    }

    func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }
}
