//
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by YuriyFpc on 02.12.2022.
//

import XCTest
@testable import QuizApp
import QuizEngine

class QuestionTests: XCTestCase {
    func test_hashValue_singleAnswer_returnTypeHash() {
        let type = "string type"
        let sut = Question.singleAnswer(type)

        XCTAssertEqual(sut.hashValue, type.hashValue)
    }

    func test_hashValue_multipleAnswer_returnTypeHash() {
        let type = "string type"
        let sut = Question.multipleAnswer(type)

        XCTAssertEqual(sut.hashValue, type.hashValue)
    }

    func test_equal_IsEqual() {
        XCTAssertEqual(        Question.singleAnswer("string type"), Question.singleAnswer("string type"))
        XCTAssertEqual(        Question.multipleAnswer("string type"), Question.multipleAnswer("string type"))
    }

    func test_equal_isNotEqual() {
        XCTAssertNotEqual(        Question.singleAnswer("string type"), Question.singleAnswer("string type2"))
        XCTAssertNotEqual(        Question.multipleAnswer("string type"), Question.multipleAnswer("string type2"))
        XCTAssertNotEqual(        Question.multipleAnswer("string type"), Question.singleAnswer("string type"))
        XCTAssertNotEqual(        Question.multipleAnswer("string type2"), Question.singleAnswer("string type"))
    }
}
