//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//

import Foundation
import UIKit

final class StatisticService: StatisticServiceProtocol{
    private var alertPresenter = AlertPresenter()
    private let storage: UserDefaults = .standard
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    private func getGameResult() -> GameResult{
        let correct = storage.integer(forKey:Keys.bestGameCorrect.rawValue)
        let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
        let date = storage.string(forKey: Keys.bestGameDate.rawValue)
        let result = GameResult(correct: correct, total: total, date: date ?? Date().dateTimeString)
        return result
    }
    private func setGameResult(gameResult:GameResult){
        storage.set(gameResult.correct, forKey: Keys.bestGameCorrect.rawValue)
        storage.set(gameResult.total, forKey: Keys.bestGameTotal.rawValue)
        storage.set(gameResult.date, forKey: Keys.bestGameDate.rawValue)
    }
    var bestGame: GameResult {
        get {
            getGameResult()
        }
        set {
            setGameResult(gameResult: newValue)
        }
    }
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalGamesGuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalGamesGuestions.rawValue)
        }
    }
    var totalAccuracy: Double{
        get{
            if (totalCorrectAnswers != 0) {Double(totalCorrectAnswers)/Double(totalQuestions) * 100} else {0}
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalQuestions = totalQuestions + amount
        totalCorrectAnswers = totalCorrectAnswers + count
        gamesCount = gamesCount + 1
        if self.bestGame.correct < count {
            let bestGame = GameResult(correct: count, total: amount, date: Date().dateTimeString)
            self.bestGame = bestGame
        }
    }
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalGamesGuestions    // Для общего количества вопросов за все игры
    }
    
}
