//
//  FavoritesInteractor.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol FavoritesInteractorProtocol {
    var favoritesMovies: [Movie] { get }
    
    init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository)
    
    func fetchFavoriteList(page: Int, completion: @escaping ResultClosure<PageInfo>)
    func removeFromFavorites(movie: Movie, completion: @escaping ResultClosure<Int>)
}

final class FavoritesInteractor: FavoritesInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let moviesStorage: MoviesRepository
    
    var favoritesMovies: [Movie] {
        return moviesStorage.fetchFavoriteMovies()
    }
        
    init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository) {
        self.networkService = networkService
        self.moviesStorage = moviesStorage
    }
    
    func fetchFavoriteList(page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkService.getFavoriteMovies(page: page) { [weak self] result in
            switch result {
            case .success(let page):
                self?.moviesStorage.saveMovies(page.movies, completion: { result in
                    switch result {
                    case .success:
                        completion(.success(page))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFromFavorites(movie: Movie, completion: @escaping ResultClosure<Int>) {
        let request = FavoriteRequest(mediaType: .movie, mediaId: movie.id, favorite: false)
        networkService.updateFavoriteStatus(request: request) { [weak self] result in
            switch result {
            case .success(let status):
                if status.success {
                    self?.moviesStorage.removeMovie(id: movie.id, completion: completion)
                } else {
                    completion(.failure(RESTError.failed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
