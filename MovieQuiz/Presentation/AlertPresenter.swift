//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 10.10.2025.
//
import UIKit
import Foundation

// MARK: - AlertPresenter
final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }

        alert.addAction(action)

        vc.present(alert, animated: true, completion: nil)
    }
}
