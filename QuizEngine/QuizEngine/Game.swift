//
//  Game.swift
//  QuizEngine
//
//  Created by YuriyFpc on 30.11.2022.
//

public final class Game<Question, Answer, R: Router> where Question == R.Question, Answer == R.Answer {
    private let flow: Flow<Question, Answer, R>

    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startingGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: [Answer]]) -> Game<Question, Answer, R> where Question == R.Question, Answer == R.Answer {
    let flow = Flow(router: router, questions: questions) { scoring($0, correctAnswers) }
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], _ correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(into: 0) { partialResult, tuple in
        partialResult += correctAnswers[tuple.key] == tuple.value ? 1 : 0
    }
}
