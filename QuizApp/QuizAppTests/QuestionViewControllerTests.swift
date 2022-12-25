//
//  QuestionViewControllerTests.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 26.11.2022.
//

import XCTest
@testable import QuizApp

class QuestionViewControllerTests: XCTestCase {
    func test_viewDidLoad_tableViewDataSourceNotNil() {
        XCTAssertNotNil(makeSUT().tableView.dataSource)
    }

    func test_viewDidLoad_tableViewDelegateNotNil() {
        XCTAssertNotNil(makeSUT().tableView.delegate)
    }

    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }

    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewDidLoad_withOneOption_rendersOneOptionText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }

    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var answer = [""]
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false, selection: {
            answer = $0
        })

        sut.tableView.select(row: 0)
        XCTAssertEqual(answer, ["A1"])

        sut.tableView.select(row: 1)
        XCTAssertEqual(answer, ["A2"])
    }

    func test_optionDeselected_withSingleSelection_doesNotNotifiesDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false, selection: { _ in
            callbackCount += 1
        })

        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)

        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }

    func test_optionSelected_WithMulipleSelectionEnable_notifiesDelegateSelecation() {
        var answer = [""]
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true, selection: {
            answer = $0
        })

        sut.tableView.select(row: 0)
        XCTAssertEqual(answer, ["A1"])

        sut.tableView.select(row: 1)
        XCTAssertEqual(answer, ["A1", "A2"])
    }

    func test_optionDeselected_WithMultipleSelectionEnable_notifiesDelegate() {
        var answer = [""]
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true, selection: {
            answer = $0
        })

        sut.tableView.select(row: 0)
        XCTAssertEqual(answer, ["A1"])

        sut.tableView.deselect(row: 0)
        XCTAssertEqual(answer, [])
    }

    // MARK: - Helpers
    func makeSUT(
        question: String = "",
        options: [String] = [],
        allowsMultipleSelection: Bool = false,
        selection: @escaping (([String]) -> Void) = { _ in }
    ) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        _ = sut.view
        return sut
    }
}
