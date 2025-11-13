//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//


import Foundation

// MARK: - StatisticService

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
    
    // MARK: - Computed Properties
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult {
        get { loadBestGame() }
        set { saveBestGame(newValue) }
    }
    
    var totalAccuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return (Double(totalCorrectAnswers) / Double(totalQuestions)) * 100
    }
    
    // MARK: - Private Computed Properties
    private var totalCorrectAnswers: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    private var totalQuestions: Int {
        get { storage.integer(forKey: Keys.totalQuestions.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestions.rawValue) }
    }
    
    // MARK: - Public Methods
    func store(correct count: Int, total amount: Int) {
        totalQuestions += amount
        totalCorrectAnswers += count
        gamesCount += 1
        
        if count > bestGame.correct {
            let newBestGame = GameResult(
                correct: count,
                total: amount,
                date: Date().dateTimeString
            )
            bestGame = newBestGame
        }
    }
    
    // MARK: - Private Methods
    private func loadBestGame() -> GameResult {
        let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
        let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
        let date = storage.string(forKey: Keys.bestGameDate.rawValue)
        
        return GameResult(
            correct: correct,
            total: total,
            date: date ?? Date().dateTimeString
        )
    }
    
    private func saveBestGame(_ game: GameResult) {
        storage.set(game.correct, forKey: Keys.bestGameCorrect.rawValue)
        storage.set(game.total, forKey: Keys.bestGameTotal.rawValue)
        storage.set(game.date, forKey: Keys.bestGameDate.rawValue)
    }
    
    // MARK: - Keys
    private enum Keys: String {
        case gamesCount              // Для счётчика сыгранных игр
        case bestGameCorrect         // Для количества правильных ответов в лучшей игре
        case bestGameTotal           // Для общего количества вопросов в лучшей игре
        case bestGameDate            // Для даты лучшей игры
        case totalCorrectAnswers     // Для общего количества правильных ответов за все игры
        case totalQuestions          // Для общего количества вопросов за все игры
    }
}
