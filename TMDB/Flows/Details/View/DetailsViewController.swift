//
//  DetailsViewController.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit
import ProgressHUD

protocol DetailsViewControllerProtocol: AnyObject {
    func setBackgroundImages(images: [Data])
    
    func updateSection(index: Int)
    
    func reloadData()
    
    func showProgressIndicator()
    func hideProgressIndicator()
    
    func updateBackground(style: BackgroundStyle)
}

final class DetailsViewController: UICollectionViewController {
    
    private var backgroundView = DetailsBackgroundView()
    
    var presenter: DetailsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        presenter?.fetchMovieDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.dataSource.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewModel = presenter?.getHeaderViewModel(indexPath: indexPath)
        let sectionType = presenter?.dataSource[indexPath.section].type
        switch sectionType {
        case .overview:
            let header = collectionView.dequeueReusableView(OverviewCollectionHeaderView.self, kind: kind, for: indexPath)
            header.viewModel = viewModel
            return header
        case .trailers, .companies, .posters, .cast, 
                .languages, .crew, .similar:
            let header = collectionView.dequeueReusableView(DetailsCollectionHeaderView.self, kind: kind, for: indexPath)
            header.viewModel = viewModel
            return header
        case .none:
            return .init()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.dataSource[section].items.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = presenter?.getViewModel(indexPath: indexPath)
        let sectionType = presenter?.dataSource[indexPath.section].type
        switch sectionType {
        case .overview:
            let cell = collectionView.dequeueReusableCell(OverviewCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .posters:
            let cell = collectionView.dequeueReusableCell(PosterCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .companies:
            let cell = collectionView.dequeueReusableCell(CompanyCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .trailers:
            let cell = collectionView.dequeueReusableCell(TrailerCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .cast:
            let cell = collectionView.dequeueReusableCell(CastCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .languages, .crew:
            let cell = collectionView.dequeueReusableCell(TextCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .similar:
            let cell = collectionView.dequeueReusableCell(MovieCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .none:
            return .init()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        updateBackgroundView(contentOffsetY: contentOffsetY)
        updateBarAppearance(contentOffsetY: contentOffsetY)
    }
    
    private func updateBackgroundView(contentOffsetY: CGFloat) {
        let topInset = collectionView.frame.height / 3
        let offset = contentOffsetY + topInset
        let alpha = max(0, min(1, offset / topInset))
        backgroundView.updateAlpha(alpha)
    }
    
    private func showNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func hideNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.shadowImage = .init()
    }
    
    private func updateBarAppearance(contentOffsetY: CGFloat) {
        let topInset = collectionView.frame.height / 9
        let scrollContentOffsetY = contentOffsetY + topInset
        if scrollContentOffsetY >= 0 {
            navigationItem.title = presenter?.title
            showNavigationBar()
        } else {
            navigationItem.title = nil
            hideNavigationBar()
        }
    }
    
    private func setupCollectionView() {
        collectionView.backgroundView = backgroundView
        setupCompositionalLayout()
        registerCollectionCells()
        registerHeaders()
    }
    
    private func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            let sectionType = self?.presenter?.dataSource[section].type
            switch sectionType {
            case .overview, .languages, .crew:
                return FlexibleVerticalLayoutSection().createLayout()
            case .posters:
                return PostersLayoutSection().createLayout()
            case .companies:
                return CompaniesLayoutSection().createLayout()
            case .trailers:
                return TrailerLayoutSection().createLayout()
            case .cast:
                return CastLayoutSection().createLayout()
            case .similar:
                return MovieLayoutSection().createLayout()
            case .none:
                return nil
            }
        }
        
        let topInset = collectionView.frame.height / 4
        collectionView.contentInset = .init(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func registerHeaders() {
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.dequeueReusableViewFromNib(DetailsCollectionHeaderView.self, kind: kind)
        collectionView.dequeueReusableViewFromNib(OverviewCollectionHeaderView.self, kind: kind)
    }
    
    private func registerCollectionCells() {
        collectionView.registerFromNib(OverviewCollectionViewCell.self)
        collectionView.registerFromNib(PosterCollectionViewCell.self)
        collectionView.registerFromNib(CompanyCollectionViewCell.self)
        collectionView.registerFromNib(TrailerCollectionViewCell.self)
        collectionView.registerFromNib(TextCollectionViewCell.self)
        collectionView.registerFromNib(CastCollectionViewCell.self)
        collectionView.registerFromNib(MovieCollectionViewCell.self)
    }
}

// MARK: - DetailsViewControllerProtocol
extension DetailsViewController: DetailsViewControllerProtocol {
    func setBackgroundImages(images: [Data]) {
        backgroundView.updateImages(images)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func updateSection(index: Int) {
        collectionView.reloadSections(.init(integer: index))
    }
    
    func showProgressIndicator() {
        ProgressHUD.animate(nil, .circleStrokeSpin)
    }
    
    func hideProgressIndicator() {
        ProgressHUD.dismiss()
    }
    
    func updateBackground(style: BackgroundStyle) {
        backgroundView.updateStyle(style: style)
    }
}
