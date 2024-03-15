//
//  NetworkService.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func generateToken(completion: @escaping ResultClosure<AuthTokenResponse>)
    func validateWithLogin(request: AuthRequest, completion: @escaping ResultClosure<AuthTokenResponse>)
    func generateSession(reguest: SessionRequest, completion: @escaping ResultClosure<SessionResponse>)
    func deleteSession(request: DeleteSessionRequest, completion: @escaping ResultClosure<DeleteSessionResponse>)
    
    func getUser(completion: @escaping ResultClosure<User>)
    
    func discoverMovies(genres: [Genre], page: Int, completion: @escaping TypeClosure<[MovieSection]>)
    func getPopularMovies(page: Int, completion: @escaping ResultClosure<PageInfo>)
    func getDetails(id: Int, completion: @escaping ResultClosure<MovieDetails>)
    
    func searchMovies(query: String, page: Int, completion: @escaping ResultClosure<PageInfo>)
    
    func getFavoriteMovies(page: Int, completion: @escaping ResultClosure<PageInfo>)
    func updateFavoriteStatus(request: FavoriteRequest, completion: @escaping ResultClosure<FavoriteResponse>)
}

final class NetworkService: NetworkServiceProtocol {
    
    private func networkRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping ResultClosure<T>) {
        guard NetworkConnectivityManager.shared.isOnline else {
            completion(.failure(RESTError.noInternetConnection))
            return
        }
        
        AF.request(endpoint)
            .validate()
            .responseDecodable(of: T.self) { response in
                print(response.debugDescription)
                switch response.result {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode,
                       let restError = RESTError(statusCode: statusCode) {
                        completion(.failure(restError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    private func fetchMovies(genre: Genre, page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkRequest(endpoint: .discover(genre: genre, page: page), completion: completion)
    }
    
    func generateToken(completion: @escaping ResultClosure<AuthTokenResponse>) {
        networkRequest(endpoint: .generateRequestToken, completion: completion)
    }
    
    func validateWithLogin(request: AuthRequest, completion: @escaping ResultClosure<AuthTokenResponse>) {
        networkRequest(endpoint: .validateToken(request: request), completion: completion)
    }
    
    func generateSession(reguest: SessionRequest, completion: @escaping ResultClosure<SessionResponse>) {
        networkRequest(endpoint: .generateSecction(reguest: reguest), completion: completion)
    }
    
    func deleteSession(request: DeleteSessionRequest, completion: @escaping ResultClosure<DeleteSessionResponse>) {
        networkRequest(endpoint: .deleteSession(request: request), completion: completion)
    }
    
    func getUser(completion: @escaping ResultClosure<User>) {
        networkRequest(endpoint: .user, completion: completion)
    }
    
    func getDetails(id: Int, completion: @escaping ResultClosure<MovieDetails>) {
        networkRequest(endpoint: .movieDetails(id: id), completion: completion)
    }
    
    func getPopularMovies(page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkRequest(endpoint: .popular(page: page), completion: completion)
    }
    
    func discoverMovies(genres: [Genre], page: Int, completion: @escaping TypeClosure<[MovieSection]>) {
        let dispatchGroup = DispatchGroup()
        var movieList: [MovieSection] = []
        
        genres.forEach { genre in
            dispatchGroup.enter()
            fetchMovies(genre: genre, page: page) { result in
                switch result {
                case .success(let page):
                    movieList.append(.init(type: .regular, genre: genre, page: page))
                case .failure:
                    break
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(movieList)
        }
    }
    
    func searchMovies(query: String, page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkRequest(endpoint: .search(query: query, page: page), completion: completion)
    }
    
    func getFavoriteMovies(page: Int, completion: @escaping ResultClosure<PageInfo>) {
        networkRequest(endpoint: .favoriteMovies(page: page), completion: completion)
    }
    
    func updateFavoriteStatus(request: FavoriteRequest, completion: @escaping ResultClosure<FavoriteResponse>) {
        let userId = UserDefaults.standard.userId
        networkRequest(endpoint: .updateFavorite(userId: userId, request: request), completion: completion)
    }
}
