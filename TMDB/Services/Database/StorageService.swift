//
//  StorageService.swift
//  TMDB
//
//  Created by Pavlo on 01.03.2024.
//

import Foundation
import RealmSwift

final class StorageService {
    private let storage: Realm?
    
    static let shared = StorageService()
    
    private init() {
        self.storage = try? Realm()
    }
    
    func fetch<T: Object>(by type: T.Type) -> [T] {
        guard let storage else { return [] }
        return storage.objects(T.self).toArray()
    }
    
    func saveObject(object: Object) throws {
        guard let storage else { return }
        storage.writeAsync {
            storage.add(object, update: .all)
        }
    }
    
    func saveAllObjects(objects: [Object]) throws {
        try objects.forEach {
            try saveObject(object: $0)
        }
    }
    
    func delete(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.delete(object)
        }
    }
    
    func deleteAll() throws {
        guard let storage else { return }
        try storage.write {
            storage.deleteAll()
        }
    }
}
