//
//  DetailsInteractor.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation
import SDWebImage

protocol DetailsInteractorProtocol {
    init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository)
    
    func fetchImages(models: [MovieImage], completion: @escaping TypeClosure<[Data]>)
    func fetchMovieDetails(id: Int, completion: @escaping ResultClosure<MovieDetails>)
    func updateFavoriteStatus(_ movie: Movie, isFavorite: Bool, completion: @escaping ResultClosure<Bool>)
    func isFavoriteMovie(id: Int) -> Bool
}

final class DetailsInteractor: DetailsInteractorProtocol {
    private let networkService: NetworkServiceProtocol
    private let moviesStorage: MoviesRepository
    
    private var favoriteMovies: [Movie] {
        return moviesStorage.fetchFavoriteMovies()
    }
    
    required init(networkService: NetworkServiceProtocol, moviesStorage: MoviesRepository) {
        self.networkService = networkService
        self.moviesStorage = moviesStorage
    }
    
    private func updateLocalFavoriteStatus(_ movie: Movie, isFavorite: Bool, completion: @escaping ResultClosure<Int>) {
        if isFavorite {
            moviesStorage.removeMovie(id: movie.id, completion: completion)
        } else {
            moviesStorage.saveMovie(movie, completion: completion)
        }
    }
    
    func fetchImages(models: [MovieImage], completion: @escaping TypeClosure<[Data]>) {
        var images: [Data?] = []
        let dispatchGroup = DispatchGroup()
        
        models.forEach {
            dispatchGroup.enter()
            SDWebImageDownloader.shared.downloadImage(with: $0.imageURL) { image,_,_,_ in 
                if let image = image {
                    images.append(image.pngData())
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images.compactMap { $0 })
        }
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping ResultClosure<MovieDetails>) {
        networkService.getDetails(id: id, completion: completion)
    }
    
    func isFavoriteMovie(id: Int) -> Bool {
        let isFavorite = favoriteMovies.contains(where: { $0.id == id })
        return isFavorite
    }
    
    func updateFavoriteStatus(_ movie: Movie, isFavorite: Bool, completion: @escaping ResultClosure<Bool>) {
        let movieId = movie.id
        let request = FavoriteRequest(mediaType: .movie, mediaId: movie.id, favorite: !isFavorite)
        networkService.updateFavoriteStatus(request: request) { [weak self] result in
            switch result {
            case .success(let status):
                if status.success {
                    self?.updateLocalFavoriteStatus(movie, isFavorite: isFavorite) { result in
                        switch result {
                        case .success:
                            completion(.success(!isFavorite))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(RESTError.failed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
