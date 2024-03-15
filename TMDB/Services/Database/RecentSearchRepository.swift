//
//  RecentSearchRepository.swift
//  TMDB
//
//  Created by Pavlo on 01.03.2024.
//

import Foundation
import RealmSwift

protocol RecentSearchRepository {
    func getRecentSearches() -> [RecentSearch]
    func saveQuery(query: RecentSearch, completion: ResultClosure<String>)
    func removeQuery(uuid: String, completion: ResultClosure<String>)
}

final class RecentSearchRepositoryImpl: RecentSearchRepository {
    private let storage: StorageService
    
    init(storage: StorageService = StorageService.shared) {
        self.storage = storage
    }
    
    func getRecentSearches() -> [RecentSearch] {
        let list = storage.fetch(by: RecentSearchDB.self)
        return list.map { RecentSearch(searchDB: $0) }
    }
    
    func saveQuery(query: RecentSearch, completion: ResultClosure<String>) {
        let recentSearchDB = RecentSearchDB(recentSearch: query)
        do {
            try storage.saveObject(object: recentSearchDB)
            completion(.success(recentSearchDB.uuid))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeQuery(uuid: String, completion: ResultClosure<String>) {
        guard let query = storage.fetch(by: RecentSearchDB.self).first(where: { $0.uuid == uuid }) else {
            completion(.failure(StorageError.noObject))
            return
        }
        
        do {
            try storage.delete(object: query)
            completion(.success(uuid))
        } catch {
            completion(.failure(error))
        }
    }
}
