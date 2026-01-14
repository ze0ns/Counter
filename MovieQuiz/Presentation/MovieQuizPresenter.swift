//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 12.01.2026.
//


import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Constants Properties
    let questionsAmount: Int = 10
    
    // MARK: - Public Properties
    var correctAnswers = 0
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?
    var givenAnswers = true
    
    // MARK: - Private Properties
    private var currentQuestionIndex: Int = 0
    private weak var viewController: MovieQuizViewController?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!

    
    init(viewController: MovieQuizViewControllerProtocol){
        self.viewController = viewController as? MovieQuizViewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    
    func handleAnswer(_ givenAnswer: Bool) {
        if let currentQuestion {
            self.givenAnswers = givenAnswer
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            viewController?.buttonYes.isEnabled = false
            viewController?.buttonNo.isEnabled = false
        } else {
            return
        }
    }
    
    // MARK: - Public Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.buttonYes.isEnabled = true
            self?.viewController?.buttonNo.isEnabled = true
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }

    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.configureImageView(isCorrect: self.givenAnswers)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.viewController?.showNextQuestionOrResults()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
}
