//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//


protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}