//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 15.11.2025.
//
import Foundation

// MARK: - MostPopularMovies
struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
    let errorMessage: String
}

// MARK: - MostPopularMovie
struct MostPopularMovie: Codable {
      let title: String
      let rating: String
      let imageURL: URL
      
      private enum CodingKeys: String, CodingKey {
      case title = "fullTitle"
      case rating = "imDbRating"
      case imageURL = "image"
      }
}
