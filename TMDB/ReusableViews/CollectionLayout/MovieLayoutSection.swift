//
//  MovieLayoutSection.swift
//  TMDB
//
//  Created by Pavlo on 13.03.2024.
//

import UIKit

struct MovieLayoutSection: CollectionLayoutSetion {
    func createLayout() -> NSCollectionLayoutSection {
        let header = createHeaderSupplementaryItem()
        let item = createItem()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 15.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 10.0, bottom: 10.0, trailing: 10.0)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
