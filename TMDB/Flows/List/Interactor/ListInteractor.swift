//
//  ListInteractor.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import Foundation

protocol ListInteractorProtocol {
    init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository)
    
    func fetchMovies(genre: Genre, page: Int, completion: @escaping TypeClosure<[MovieSection]>)
    func addMovieToFavorites(_ movie: Movie, completion:  @escaping ResultClosure<Int>)
}

final class ListInteractor: ListInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let moviesStorage: MoviesRepository
    
    required init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository) {
        self.networkService = networkService
        self.moviesStorage = moviesStorage
    }
    
    private func saveToFavorites(movie: Movie, completion: @escaping ResultClosure<Int>) {
        let request = FavoriteRequest(mediaType: .movie, mediaId: movie.id, favorite: true)
        networkService.updateFavoriteStatus(request: request) { [weak self] result in
            switch result {
            case .success(let status):
                if status.success {
                    self?.moviesStorage.saveMovie(movie, completion: completion)
                } else {
                    completion(.failure(RESTError.failed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovies(genre: Genre, page: Int, completion: @escaping TypeClosure<[MovieSection]>) {
        networkService.discoverMovies(genres: [genre], page: page, completion: completion)
    }
    
    func addMovieToFavorites(_ movie: Movie, completion: @escaping ResultClosure<Int>) {
        moviesStorage.fetchMovie(id: movie.id) { [weak self] favorite in
            if favorite != nil {
                completion(.success(movie.id))
            } else {
                self?.saveToFavorites(movie: movie, completion: completion)
            }
        }
    }
}
