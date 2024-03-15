//
//  GenresViewController.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit
import ProgressHUD

protocol GenresViewControllerProtocol: AnyObject {
    func reloadData()
    
    func showProgressIndicator()
    func hideProgressIndicator()
    
    func updateBackground(style: BackgroundStyle)
}

final class GenresViewController: UICollectionViewController {
    
    private var backgroundView = BackgroundView()
    
    var presenter: GenresPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        presenter?.fetchMovies()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter?.dataSource.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let viewModel = presenter?.getHeaderViewModel(indexPath: indexPath)
        let headerType = presenter?.dataSource[indexPath.section].type
        switch headerType {
        case .popular:
            let header = collectionView.dequeueReusableView(PopularCollectionHeaderView.self, kind: kind, for: indexPath)
            header.viewModel = viewModel
            return header
        case .regular:
            let header = collectionView.dequeueReusableView(GenreCollectionHeaderView.self, kind: kind, for: indexPath)
            header.viewModel = viewModel
            return header
        case .none:
            return .init()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.dataSource[section].page.movies.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = presenter?.dataSource[indexPath.section].type
        let viewModel = presenter?.getViewModel(indexPath: indexPath)
        switch cellType {
        case .popular:
            let cell = collectionView.dequeueReusableCell(PopularMovieCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        case .regular:
            let cell = collectionView.dequeueReusableCell(MovieCollectionViewCell.self, for: indexPath)
            cell.viewModel = viewModel
            return cell
        default:
            return .init()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.showMovieDetails(indexPath: indexPath)
    }
    
    private func setupNavigationBar() {
        let logoutButtonImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        let logoutButton = UIBarButtonItem(image: logoutButtonImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(logoutButtonAction))
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    private func setupCollectionView() {
        collectionView.backgroundView = backgroundView
        setupCompositionalLayout()
        registerHeaders()
        registerCollectionCells()
    }
    
    private func updatePopularPageIndicator(with page: Int) {
        collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).forEach {
            if let headerView = $0 as? PopularCollectionHeaderView {
                headerView.updateCurrentPage(to: page)
                return
            }
        }
    }
    
    private func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            let sectionType = self?.presenter?.dataSource[section].type
            switch sectionType {
            case .popular:
                var popularMovieLayout = PopularMovieLayout()
                popularMovieLayout.currentOffset = { [weak self] offset in
                    guard let self = self else { return }
                    let page = Int(round(offset.x / view.bounds.width))
                    updatePopularPageIndicator(with: page)
                }
                return popularMovieLayout.createLayout()
            case .regular:
                return MovieLayoutSection().createLayout()
            default:
                return nil
            }
        }
        
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func registerHeaders() {
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.dequeueReusableViewFromNib(PopularCollectionHeaderView.self, kind: kind)
        collectionView.dequeueReusableViewFromNib(GenreCollectionHeaderView.self, kind: kind)
    }
    
    private func registerCollectionCells() {
        collectionView.registerFromNib(PopularMovieCollectionViewCell.self)
        collectionView.registerFromNib(MovieCollectionViewCell.self)
    }
    
    @objc
    private func logoutButtonAction() {
        presenter?.logout()
    }
}

// MARK: - GenresViewControllerProtocol
extension GenresViewController: GenresViewControllerProtocol {
    func reloadData() {
        collectionView.reloadData()
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
