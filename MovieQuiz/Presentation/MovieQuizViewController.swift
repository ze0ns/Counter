import UIKit

final class MovieQuizViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var buttonYes: UIButton!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    private var statisticService: StatisticServiceProtocol = StatisticService()
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
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }

    // MARK: - Private Methods
 
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    func configureImageView(isCorrect: Bool){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func showNextQuestionOrResults() {
        let statistic = statisticService
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        if presenter.isLastQuestion() {
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            let model = AlertModel(title: "Этот раунд окончен!",
                                   message: "Ваш результат: \(presenter.correctAnswers)/10 \n Количество сигранных квизов \(statistic.gamesCount) \n Рекорд \(statistic.bestGame.correct)/10 (\(statistic.bestGame.date)) \n Средняя точность: \(String(format: "%.2f", statistic.totalAccuracy))%",
                                   buttonText: "Сыграть ещё раз")
            { [weak self] in
                guard let self = self else { return }
                self.presenter.resetQuestionIndex()
                self.presenter.correctAnswers = 0
                self.presenter.questionFactory?.requestNextQuestion()
            }
            UserDefaults.standard.set(presenter.correctAnswers, forKey: "counterValue")
            alertPresenter.show(in: self, model: model)
        } else {
            presenter.switchToNextQuestion()
            presenter.questionFactory?.requestNextQuestion()
        }
    }
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        let errorModel = AlertModel(title: "Ошибка", message: "Сообщение ошибки", buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.presenter.restartGame()
        }
        alertPresenter.show(in: self, model: errorModel)
    }

}

