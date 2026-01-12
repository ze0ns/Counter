import UIKit

final class MovieQuizViewController: UIViewController  {
    
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var presenter: MovieQuizPresenter!
    
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
        configureImageView()
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }

    // MARK: - Private Methods
 
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        let errorModel = AlertModel(title: "Ошибка", message: "Сообщение ошибки", buttonText: "Попробовать еще раз") {
            print("retry")
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            self.presenter.restartGame()
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
            presenter.correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }

}

