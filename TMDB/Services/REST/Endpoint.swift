//
//  Endpoint.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation
import Alamofire

enum Endpoint: URLRequestConvertible {
    case generateRequestToken
    case validateToken(request: AuthRequest)
    case generateSecction(reguest: SessionRequest)
    case deleteSession(request: DeleteSessionRequest)
    case user
    
    case discover(genre: Genre, page: Int)
    case popular(page: Int)
    case movieDetails(id: Int)
    
    case search(query: String, page: Int)
    
    case favoriteMovies(page: Int)
    case updateFavorite(userId: Int, request: FavoriteRequest)
    
    var path: String {
        switch self {
        case .generateRequestToken:
            return "/authentication/token/new"
        case .validateToken:
            return "/authentication/token/validate_with_login"
        case .generateSecction:
            return "/authentication/session/new"
        case .deleteSession:
            return "/authentication/session"
        case .user:
            return "/account"
        case .discover, .popular:
            return "/discover/movie"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .search:
            return "/search/movie"
        case .favoriteMovies:
            return "/account/10584380/favorite/movies"
        case .updateFavorite(let userId, _):
            return "/account/\(userId)/favorite"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .validateToken, .generateSecction, .updateFavorite:
            return .post
        case .deleteSession:
            return .delete
        case .generateRequestToken, .user, .discover, .popular, .movieDetails,
                .search, .favoriteMovies:
            return .get
        }
    }
    
    var parameters: [URLQueryItem] {
        var parameters: [URLQueryItem] = []
        switch self {
        case .discover(let genre, let page):
            parameters = [
                .init(name: "page", value: "\(page)"),
                .init(name: "with_genres", value: "\(genre.rawValue)")
            ]
        case .popular(let page):
            parameters = [
                .init(name: "include_adult", value: "true"),
                .init(name: "include_video", value: "true"),
                .init(name: "language", value: "en"),
                .init(name: "sort_by", value: "popularity.desc"),
                .init(name: "page", value: "\(page)"),
            ]
        case .movieDetails:
            parameters = [
                .init(name: "append_to_response", value: "videos,images,credits,similar")
            ]
        case .search(let query, let page):
            parameters = [
                .init(name: "query", value: query),
                .init(name: "include_video", value: "true"),
                .init(name: "sort_by", value: "popularity.desc"),
                .init(name: "page", value: "\(page)")
            ]
        case .generateRequestToken, .validateToken, .generateSecction, .deleteSession, .user:
            break
        case .favoriteMovies(let page):
            parameters = [
                .init(name: "language", value: "en"),
                .init(name: "page", value: "\(page)"),
                .init(name: "sort_by", value: "created_at.desc")
            ]
            return parameters
        case .updateFavorite:
            return parameters
        }
        
        parameters.append(.init(name: "api_key", value: Constants.apiKey))
        return parameters
    }
    
    var httpBody: [String: Any]? {
        switch self {
        case .validateToken(let request):
            return request.toJSON()
        case .generateSecction(let request):
            return request.toJSON()
        case .deleteSession(let request):
            return request.toJSON()
        case .updateFavorite(_, let request):
            return request.toJSON()
        default:
            return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .user, .updateFavorite, .favoriteMovies:
            guard let token = Constants.token else { return [:] }
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        let baseURL = try Constants.baseURL.asURL()
        let fullURL = baseURL.appendingPathComponent(path)
        
        var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters
        
        var request = URLRequest.init(url: try components?.asURL() ?? fullURL)
        request.httpMethod = method.rawValue
        
        if !headers.isEmpty {
            headers.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        if let httpBody = httpBody, let httpBodyData = try? JSONSerialization.data(withJSONObject: httpBody) {
            request.httpBody = httpBodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}
