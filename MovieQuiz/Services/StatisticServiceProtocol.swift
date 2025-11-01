//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 01.11.2025.
//
import UIKit
import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame:  GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int) 
}
