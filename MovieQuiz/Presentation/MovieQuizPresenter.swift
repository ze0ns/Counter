//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 12.01.2026.
//


import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    let questionsAmount: Int = 10
    var correctAnswers = 0
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController){
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        statisticService = StatisticService()
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
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        showNetworkError(message: message)
    }
    func showNetworkError(message: String) {
        viewController?.activityIndicator.isHidden = true
        let errorModel = AlertModel(title: "Ошибка", message: "Сообщение ошибки", buttonText: "Попробовать еще раз") {
            print("retry")
            self.resetQuestionIndex()
            self.correctAnswers = 0
            self.restartGame()
        }
        alertPresenter.show(in: self.viewController!, model: errorModel)
    }
    func showNextQuestionOrResults() {
        let statistic = statisticService
        guard let statistic = statistic else {return}
        viewController?.imageView.layer.borderColor = UIColor.ypBlack.cgColor
        if isLastQuestion() {
            statisticService.store(correct: self.correctAnswers, total: questionsAmount)
            let model = AlertModel(title: "Этот раунд окончен!",
                                   message: "Ваш результат: \(correctAnswers)/10 \n Количество сигранных квизов \(statistic.gamesCount) \n Рекорд \(statistic.bestGame.correct)/10 (\(statistic.bestGame.date)) \n Средняя точность: \(String(format: "%.2f", statistic.totalAccuracy))%",
                                   buttonText: "Сыграть ещё раз")
            {
                self.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            UserDefaults.standard.set(self.correctAnswers, forKey: "counterValue")
            alertPresenter.show(in: self.viewController!, model: model)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
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
