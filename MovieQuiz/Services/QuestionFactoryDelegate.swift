//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//

// MARK: - QuestionFactoryDelegate

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error) 
}
