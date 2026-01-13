//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//
import Foundation

// MARK: - AlertModel
struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
