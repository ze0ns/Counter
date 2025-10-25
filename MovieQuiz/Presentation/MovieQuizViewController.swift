import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        questionFactory.requestNextQuestion()
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        questionFactory.requestNextQuestion()
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    override func viewDidLoad() {
        configureImageView()
        super.viewDidLoad()
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        self.questionFactory.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    private func configureImageView(){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func showAnswerResult(isCorrect: Bool) {
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
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        if currentQuestionIndex == questionsAmount - 1 {
            let model = AlertModel(title: "Этот раунд окончен!", message: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть ещё раз") {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
            alertPresenter.show(in: self, model: model)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
}


//let alert = UIAlertController(
//    title: "Этот раунд окончен!",
//    message: "Ваш результат: \(correctAnswers)/10",
//    preferredStyle: .alert)
//let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) {[weak self] _ in
//    guard let self = self else { return }
//    self.currentQuestionIndex = 0
//    self.correctAnswers = 0
//    questionFactory.requestNextQuestion()
//}
//alert.addAction(action)
//self.present(alert, animated: true, completion: nil)
