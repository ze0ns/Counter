//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 09.10.2025.
//

import UIKit

// MARK: - QuestionFactory

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Properties
    weak var delegate: QuestionFactoryDelegate?
    private let questions: [QuizQuestion] = QuizQuestion.mockQuestions
    
    // MARK: - Setup
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
