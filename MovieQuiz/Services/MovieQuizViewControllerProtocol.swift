//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 13.01.2026.
//
import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func configureImageView(isCorrect: Bool)
    func show(quiz step: QuizStepViewModel)
    func showNextQuestionOrResults()
    func showNetworkError(message: String)
}
