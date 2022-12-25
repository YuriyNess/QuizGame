//
//  Flow.swift
//  QuizEngine
//
//  Created by YuriyFpc on 31.10.2022.
//

class Flow<Question, Answer, R: Router> where R.Answer == Answer, R.Question == Question {
    let router: R
    let questions: [Question]
    var answers: [Question: [Answer]] = [:]
    var scoring: ([Question: [Answer]]) -> Int

    init(router: R, questions: [Question], scoring:  @escaping ([Question: [Answer]]) -> Int) {
        self.router = router
        self.questions = questions
        self.scoring = scoring
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(
                question: firstQuestion,
                answerCallback: self.routeNext(from: firstQuestion))
        } else {
            router.routeTo(makeResults())
        }
    }

    func routeNext(from question: Question) -> ([Answer]) -> Void {
        return { [weak self] questionAnswer in
            guard let self = self else { return }
            guard let index = self.questions.firstIndex(of: question) else { return }
            self.answers[question] = questionAnswer
            let nextIndex = self.questions.index(after: index)
            if nextIndex < self.questions.count {
                let nextQuestion = self.questions[nextIndex]

                self.router.routeTo(question: nextQuestion, answerCallback: self.routeNext(from: nextQuestion))
            } else {
                self.router.routeTo( self.makeResults())
            }
        }
    }

    private func makeResults() -> Result<Question, Answer> {
        Result(answers: answers, score: scoring(answers))
    }
}
