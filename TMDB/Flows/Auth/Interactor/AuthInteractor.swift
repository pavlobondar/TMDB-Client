//
//  AuthInteractor.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

protocol AuthInteractorProtocol {
    init(networkService: NetworkServiceProtocol)
    
    func login(username: String, password: String, completion: @escaping ResultClosure<SessionResponse>)
}

final class AuthInteractor: AuthInteractorProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    required init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    private func fetchUserId(completion: @escaping ResultClosure<Int>) {
        networkService.getUser { result in
            switch result {
            case .success(let user):
                completion(.success(user.id))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchSession(request: SessionRequest, completion: @escaping ResultClosure<SessionResponse>) {
        networkService.generateSession(reguest: request, completion: completion)
    }
    
    private func validateLogin(request: AuthRequest, completion: @escaping ResultClosure<SessionResponse>) {
        networkService.validateWithLogin(request: request) { [weak self] result in
            switch result {
            case .success(let response):
                let reguest = SessionRequest(token: response.requestToken)
                self?.fetchSession(request: reguest, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping ResultClosure<SessionResponse>) {
        networkService.generateToken() { [weak self] result in
            switch result {
            case .success(let response):
                let request = AuthRequest(username: username, password: password, token: response.requestToken)
                self?.validateLogin(request: request) { result in
                    switch result {
                    case .success(let response):
                        self?.fetchUserId { result in
                            switch result {
                            case .success(let userId):
                                UserDefaults.standard.userId = userId
                                KeychainService.shared.save(value: response.sessionId, for: .session)
                                completion(.success(response))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
