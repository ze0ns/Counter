//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//

// MARK: - QuestionFactoryDelegate

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
