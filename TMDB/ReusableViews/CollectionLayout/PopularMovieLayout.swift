//
//  PopularMovieLayout.swift
//  TMDB
//
//  Created by Pavlo on 13.03.2024.
//

import UIKit

struct PopularMovieLayout: CollectionLayoutSetion {
    var currentOffset: TypeClosure<CGPoint>?
    
    func createLayout() -> NSCollectionLayoutSection {
        let header = createHeaderSupplementaryItem()
        let item = createItem()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        section.visibleItemsInvalidationHandler = { _, offset, _ -> Void in
            currentOffset?(offset)
        }
        
        return section
    }
    
    func createHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .bottom)
    }
}
