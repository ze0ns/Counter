//
//  MostPopularMovies 2.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 13.01.2026.
//
import Foundation

// MARK: - MostPopularMovies
struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
    let errorMessage: String
}
