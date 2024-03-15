//
//  MoviesRepository.swift
//  TMDB
//
//  Created by Pavlo on 01.03.2024.
//

import Foundation
import RealmSwift

protocol MoviesRepository: AnyObject {
    func fetchFavoriteMovies() -> [Movie]
    func fetchMovie(id: Int, completion: TypeClosure<Movie?>)
    func saveMovies(_ movies: [Movie], completion: ResultClosure<Void>)
    func saveMovie(_ movie: Movie, completion: ResultClosure<Int>)
    func removeMovie(id: Int, completion: ResultClosure<Int>)
}

final class MoviesRepositoryImpl: MoviesRepository {
    private let storage: StorageService
    
    init(storage: StorageService = StorageService.shared) {
        self.storage = storage
    }
    
    func fetchFavoriteMovies() -> [Movie] {
        let list = storage.fetch(by: MovieDB.self)
        return list.map { Movie(movieDB: $0) }
    }
    
    func fetchMovie(id: Int, completion: TypeClosure<Movie?>) {
        if let movie = storage.fetch(by: MovieDB.self).first(where: { $0.id == id }) {
            completion(Movie(movieDB: movie))
        } else {
            completion(nil)
        }
    }
    
    func saveMovies(_ movies: [Movie], completion: ResultClosure<Void>) {
        let moviesDB = movies.compactMap { MovieDB(movie: $0) }
        do {
            try storage.saveAllObjects(objects: moviesDB)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveMovie(_ movie: Movie, completion: ResultClosure<Int>) {
        let movieDB = MovieDB(movie: movie)
        do {
            try storage.saveObject(object: movieDB)
            completion(.success(movieDB.id))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeMovie(id: Int, completion: ResultClosure<Int>) {
        guard let movie = storage.fetch(by: MovieDB.self).first(where: { $0.id == id }) else {
            completion(.failure(StorageError.noObject))
            return
        }
        
        do {
            try storage.delete(object: movie)
            completion(.success(id))
        } catch {
            completion(.failure(error))
        }
    }
}
