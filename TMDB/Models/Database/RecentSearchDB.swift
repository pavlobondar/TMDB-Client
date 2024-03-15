//
//  RecentSearchDB.swift
//  TMDB
//
//  Created by Pavlo on 28.02.2024.
//

import Foundation
import RealmSwift

class RecentSearchDB: Object {
    @Persisted(primaryKey: true) var uuid: String
    @Persisted var query: String = ""
    @Persisted var date: Date = Date()
    
    convenience init(recentSearch: RecentSearch) {
        self.init()
        self.uuid = recentSearch.uuid
        self.query = recentSearch.query
        self.date = recentSearch.date
    }
}
