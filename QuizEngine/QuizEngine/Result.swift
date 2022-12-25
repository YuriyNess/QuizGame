//
//  Result.swift
//  QuizEngine
//
//  Created by YuriyFpc on 01.12.2022.
//

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: [Answer]]
    public let score: Int
}
