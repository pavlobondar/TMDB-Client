//
//  GenresInteractor.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol GenresInteractorProtocol {
    init(networkService: NetworkServiceProtocol)
    
    func fetchMovieLists(genres: [Genre], page: Int, completion: @escaping ResultClosure<[MovieSection]>)
    func deleteSession(completion: @escaping ResultClosure<Bool>)
}

final class GenresInteractor: GenresInteractorProtocol {
 
    private let networkService: NetworkServiceProtocol
    
    required init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    private func fetchPopularMovies(completion: @escaping TypeClosure<MovieSection>) {
        networkService.getPopularMovies(page: 1) { result in
            switch result {
            case .success(let page):
                completion(.init(type: .popular, genre: nil, page: page))
            case .failure(_):
                completion(.init(type: .popular, genre: nil, page: .init(movies: [])))
            }
        }
    }
    
    func fetchMovieLists(genres: [Genre], page: Int, completion: @escaping ResultClosure<[MovieSection]>) {
        guard NetworkConnectivityManager.shared.isOnline else {
            completion(.failure(RESTError.noInternetConnection))
            return
        }
        
        var movieList: [MovieSection] = []
        
        let dispathGroup = DispatchGroup()
        dispathGroup.enter()
        
        fetchPopularMovies { popularMovies in
            movieList.append(popularMovies)
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        networkService.discoverMovies(genres: genres, page: page) { regularMovies in
            movieList.append(contentsOf: regularMovies)
            dispathGroup.leave()
        }
        
        dispathGroup.notify(queue: .main) {
            completion(.success(movieList.sorted(by: { $0.type.rawValue < $1.type.rawValue })))
        }
    }
    
    func deleteSession(completion: @escaping ResultClosure<Bool>) {
        guard let sessionId = KeychainService.shared.get(for: .session) else { return }
        networkService.deleteSession(request: .init(sessionId: sessionId)) { result in
            switch result {
            case .success(let response):
                KeychainService.shared.removeValue(for: .session)
//                try? StorageService.shared.deleteAll()
                UserDefaults.standard.resetDefaults()
                completion(.success(response.success))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
