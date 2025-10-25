//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//


struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}