//
//  PopularCollectionHeaderView.swift
//  TMDB
//
//  Created by Pavlo on 04.03.2024.
//

import UIKit

final class PopularCollectionHeaderViewModel: HeaderViewModel {
    let numberOfPages: Int
    let currentPage: Int
        
    init(numberOfPages: Int, currentPage: Int) {
        self.numberOfPages = numberOfPages
        self.currentPage = currentPage
    }
}

final class PopularCollectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private var actionHandler: VoidClosure?
    
    var viewModel: HeaderViewModel? {
        didSet {
            guard let viewModel = viewModel as? PopularCollectionHeaderViewModel else {
                return
            }
            setupHeader(viewModel: viewModel)
        }
    }
    
    func updateCurrentPage(to page: Int) {
        guard page < pageControl.numberOfPages else { return }
        pageControl.currentPage = page
    }
    
    private func setupHeader(viewModel: PopularCollectionHeaderViewModel) {
        pageControl.numberOfPages = viewModel.numberOfPages
        pageControl.currentPage = viewModel.currentPage
        pageControl.isUserInteractionEnabled = false
    }
}
