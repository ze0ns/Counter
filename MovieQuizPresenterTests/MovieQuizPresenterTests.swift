//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Oschepkov Aleksandr on 13.01.2026.
//
import XCTest
@testable import MovieQuiz
final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol{
    func showLoadingIndicator() {

    }
    
    func hideLoadingIndicator() {
    
    }
    
    func configureImageView(isCorrect: Bool) {
    
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }
    
    func showNextQuestionOrResults() {
        
    }
    
    func showNetworkError(message: String) {
        
    }
    
    
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
         let viewControllerMock = MovieQuizViewControllerMock()
         let sut = MovieQuizPresenter(viewController: viewControllerMock)
         
         let emptyData = Data()
         let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
         let viewModel = sut.convert(model: question)
         
         XCTAssertNotNil(viewModel.image)
         XCTAssertEqual(viewModel.question, "Question Text")
         XCTAssertEqual(viewModel.questionNumber, "1/10")
     }
}
