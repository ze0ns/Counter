//
//  MoviesLoading.swift
//  MovieQuiz
//
//  Created by Oschepkov Aleksandr on 15.11.2025.
//


import Foundation

protocol MoviesLoading{
    func loadMovies(handlet: @escaping (Result<MostPopularMovies,Error>) -> Void)
}

struct MoviesLoader: MoviesLoading{
    // MARK: - Properties
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Private Methods
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    // MARK: - Public Methods
    func loadMovies(handlet handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
