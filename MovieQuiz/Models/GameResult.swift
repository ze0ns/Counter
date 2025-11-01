//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//

import Foundation
import UIKit

struct GameResult {
    let correct: Int
    let total: Int
    let date: String
    
    func isBetterThan(_ another: GameResult) -> Bool {
            correct > another.correct
        }
}
