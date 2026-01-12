import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var correctAnswers = 0
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Actions
    @IBAction func yesButtonClicked(_ sender: Any) {
        presenter.handleAnswer(true)
        presenter.currentQuestion = currentQuestion
    }
    @IBAction func noButtonClicked(_ sender: Any) {
        presenter.handleAnswer(false)
        presenter.currentQuestion = currentQuestion
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        configureImageView()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Private Methods
 
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        let errorModel = AlertModel(title: "Ошибка", message: "Сообщение ошибки", buttonText: "Попробовать еще раз") {
            print("retry")
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter.show(in: self, model: errorModel)
    }
    private func configureImageView(){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }

    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        let statistic = statisticService
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        if presenter.isLastQuestion() {
            statistic.store(correct: self.correctAnswers, total: presenter.questionsAmount)
            let model = AlertModel(title: "Этот раунд окончен!",
                                   message: "Ваш результат: \(correctAnswers)/10 \n Количество сигранных квизов \(statistic.gamesCount) \n Рекорд \(statistic.bestGame.correct)/10 (\(statistic.bestGame.date)) \n Средняя точность: \(String(format: "%.2f", statistic.totalAccuracy))%",
                                   buttonText: "Сыграть ещё раз")
            {
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            UserDefaults.standard.set(self.correctAnswers, forKey: "counterValue")
            alertPresenter.show(in: self, model: model)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}

