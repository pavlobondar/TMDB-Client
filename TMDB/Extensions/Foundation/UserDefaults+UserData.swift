//
//  UserDefaults+UserData.swift
//  TMDB
//
//  Created by Pavlo on 12.03.2024.
//

import Foundation


enum UserDefaultsKeys: String {
    case userId
}

extension UserDefaults {
    
    var userId: Int {
        get {
            integer(forKey: UserDefaultsKeys.userId.rawValue)
        }
        set {
            set(newValue, forKey: UserDefaultsKeys.userId.rawValue)
        }
    }
 
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
