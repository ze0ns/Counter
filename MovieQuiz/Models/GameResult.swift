//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//

import Foundation

// MARK: - GameResult
struct GameResult {
    let correct: Int
    let total: Int
    let date: String
    
    func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
}
