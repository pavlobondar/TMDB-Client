//
//  CompanyCellViewModel.swift
//  TMDB
//
//  Created by Pavlo on 01.02.2024.
//

import Foundation

final class CompanyCellViewModel: CellViewModel {
    private let company: Company
    
    var companyLogoURL: URL? {
        return company.logoURL
    }
    
    var title: String {
        return company.name
    }
    
    var subtitle: String {
        return company.originCountry
    }
    
    init(company: Company) {
        self.company = company
    }
}
