//
//  GameTests.swift
//  QuizEngineTests
//
//  Created by YuriyFpc on 30.11.2022.
//

import XCTest
import QuizEngine

class GameTests: XCTestCase {

    var game: Game<String, String, RouterSpy>!
    let router = RouterSpy()

    override func setUp() {
        super.setUp()
        game = startingGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": ["A1"], "Q2": ["A2"]])
    }

    func test_startingGame_answer0OfTwoCorrectly_scores0() {
        router.answerCallBack(["wrong"])
        router.answerCallBack(["wrong"])

        XCTAssertEqual(router.result?.score, 0)
    }

    func test_startingGame_answerOneOfTwoCorrectly_scores1() {
        router.answerCallBack(["A1"])
        router.answerCallBack(["wrong"])

        XCTAssertEqual(router.result?.score, 1)
    }

    func test_startingGame_answerTwoOfTwoCorrectly_scores1() {
        router.answerCallBack(["A1"])
        router.answerCallBack(["A2"])

        XCTAssertEqual(router.result?.score, 2)
    }
}


