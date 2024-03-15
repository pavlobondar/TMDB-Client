//
//  CollectionLayout.swift
//  TMDB
//
//  Created by Pavlo on 13.03.2024.
//

import UIKit

protocol CollectionLayoutSetion {
    func createLayout() -> NSCollectionLayoutSection
    func createHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem
    func createItem() -> NSCollectionLayoutItem
}

extension CollectionLayoutSetion {
    func createHeaderSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
