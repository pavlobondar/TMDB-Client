//
//  SearchInteractor.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol SearchInteractorProtocol {
    var searchSuggestions: [RecentSearch] { get }
    
    init(networkService: NetworkServiceProtocol,
         recentSearchStorage: RecentSearchRepository,
         moviesStorage: MoviesRepository)
    
    func fetchMovies(query: String, page: Int, completion: @escaping ResultClosure<PageInfo>)
    
    func getFirstSearchSuggestions(_ count: Int) -> [RecentSearch]
    func saveQuery(_ query: String)
    func removeSuggestion(uuid: String, completion: ResultClosure<String>)
    
    func addMovieToFavorites(_ movie: Movie, completion: @escaping ResultClosure<Int>)
}

final class SearchInteractor: SearchInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let recentSearchStorage: RecentSearchRepository
    private let moviesStorage: MoviesRepository
    
    var searchSuggestions: [RecentSearch] {
        return recentSearchStorage.getRecentSearches()
    }
    
    required init(networkService: NetworkServiceProtocol,
                  recentSearchStorage: RecentSearchRepository,
                  moviesStorage: MoviesRepository) {
        self.networkService = networkService
        self.recentSearchStorage = recentSearchStorage
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
    
    func fetchMovies(query: String, page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkService.searchMovies(query: query, page: page, completion: completion)
    }
    
    func getFirstSearchSuggestions(_ count: Int) -> [RecentSearch] {
        guard count > 0 else { return [] }
        let suggestions = searchSuggestions.reversed().prefix(count)
        return Array(suggestions)
    }
    
    func saveQuery(_ query: String) {
        guard !searchSuggestions.contains(where: { $0.query == query }) else { return }
        let suggestion = RecentSearch(query: query)
        recentSearchStorage.saveQuery(query: suggestion) { _ in }
    }
    
    func removeSuggestion(uuid: String, completion: ResultClosure<String>) {
        recentSearchStorage.removeQuery(uuid: uuid, completion: completion)
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
