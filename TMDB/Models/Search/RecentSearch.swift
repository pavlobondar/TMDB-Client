//
//  RecentSearch.swift
//  TMDB
//
//  Created by Pavlo on 28.02.2024.
//

import Foundation

struct RecentSearch {
    let uuid: String
    let query: String
    let date: Date
    
    init(uuid: String, query: String, date: Date) {
        self.uuid = uuid
        self.query = query
        self.date = date
    }
    
    init(query: String) {
        self.uuid = UUID().uuidString
        self.query = query
        self.date = Date()
    }
    
    init(searchDB: RecentSearchDB) {
        self.uuid = searchDB.uuid
        self.query = searchDB.query
        self.date = searchDB.date
    }
}
