//
//  QuizEngineTests.swift
//  QuizEngineTests
//
//  Created by YuriyFpc on 31.10.2022.
//

import XCTest
@testable import QuizEngine

class FlowTests: XCTestCase {
    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()

        XCTAssertTrue(router.questions.isEmpty)
    }

    func test_start_withOneQuestion_routesToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.questions, ["Q1"])
    }

    func test_start_withTwoQuestions_routesToFirstQuestion() {
        makeSUT(questions: ["Q1","Q2"]).start()

        XCTAssertEqual(router.questions, ["Q1"])
    }

    func test_startTwice_withTwoQuestions_routesToFirstQuestion() {
        let sut = makeSUT(questions: ["Q1","Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.questions, ["Q1","Q1"])
    }

    func test_start_withTwoQuestions_routesToFirstThanSecondQuestions() {
        let sut = makeSUT(questions: ["Q1","Q2"])

        sut.start()
        router.answerCallBack([""])

        XCTAssertEqual(router.questions, ["Q1","Q2"])
    }

    func test_start_withTwoQuestions_routesToFirstThanSecondQuestionsNotThird() {
        let sut = makeSUT(questions: ["Q1","Q2"])

        sut.start()
        router.answerCallBack([""])
        router.answerCallBack([""])

        XCTAssertEqual(router.questions.count, 2)
    }

    func test_start_withThreeQuestions_routesToFirstThanSecondThanThirdQuestions() {
        let sut = makeSUT(questions: ["Q1","Q2","Q3"])

        sut.start()
        router.answerCallBack([""])
        router.answerCallBack([""])

        XCTAssertEqual(router.questions, ["Q1","Q2","Q3"])
    }

    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()

        XCTAssertNotNil(router.result)
    }

    func test_start_withOneQuestions_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertNil(router.result)
    }

    func test_startOneQuestionAnswerOneQuestion_withOneQuestion_RoutesToResult() {
        let sut = makeSUT(questions: ["Q1"])
        
        sut.start()
        router.answerCallBack(["A1"])

        XCTAssertEqual(router.result?.answers, ["Q1":["A1"]])
    }

    func test_startAndAnswerTwoQuestions_withTwoQuestions_RoutesToResult() {
        let sut = makeSUT(questions: ["Q1","Q2"])

        sut.start()
        router.answerCallBack(["A1"])
        router.answerCallBack(["A2"])

        XCTAssertEqual(router.result?.answers, ["Q1":["A1"], "Q2":["A2"]])
    }

    func test_startAndAnswerTwoQuestions_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1","Q2"], scoring: { _ in return 10 })

        sut.start()
        router.answerCallBack(["A1"])
        router.answerCallBack(["A2"])

        XCTAssertEqual(router.result?.score, 10)
    }

    func test_startAndAnswerTwoQuestions_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers = [String: [String]]()
        let sut = makeSUT(questions: ["Q1","Q2"], scoring: { answers -> Int in
            receivedAnswers = answers
            return 10
        })

        sut.start()
        router.answerCallBack(["A1"])
        router.answerCallBack(["A2"])

        XCTAssertEqual(receivedAnswers, ["Q1":["A1"], "Q2":["A2"]])
    }

    // MARK: - Helper
    func makeSUT(questions: [String], scoring:  @escaping ([String: [String]]) -> Int = { _ in -1 }) -> Flow<String, String, RouterSpy> {
        Flow(router: router, questions: questions, scoring: scoring)
    }
}
