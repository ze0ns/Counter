//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//

import Foundation

// MARK: StatisticServiceProtocol

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame:  GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int) 
}
