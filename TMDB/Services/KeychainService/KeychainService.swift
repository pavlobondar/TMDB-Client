//
//  KeychainService.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import KeychainSwift

final class KeychainService {
    
    enum KeychainKey: String {
        case session = "tmdb_session_id"
    }
    
    static var shared = KeychainService()
    
    private var keychain = KeychainSwift()
    
    private init() {}
    
    func save(value: String, for key: KeychainKey) {
        keychain.set(value, forKey: key.rawValue)
    }
    
    func get(for key: KeychainKey) -> String? {
        return keychain.get(key.rawValue)
    }
    
    func removeValue(for key: KeychainKey) {
        keychain.delete(key.rawValue)
    }
}
