//
//  FlexibleVerticalLayoutSection.swift
//  TMDB
//
//  Created by Pavlo on 13.03.2024.
//

import UIKit

struct FlexibleVerticalLayoutSection: CollectionLayoutSetion {
    func createLayout() -> NSCollectionLayoutSection {
        let header = createHeaderSupplementaryItem()
        let item = createItem()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 10.0, bottom: 0.0, trailing: 10.0)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        return item
    }
}
