//
//  FavoritesPresenter.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol FavoritesPresenterProtocol {
    var dataSource: [Movie] { get }
    
    func fetchFavorites()
    func fetchFavoritesIfNeeded(indexPath: IndexPath)
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel?
    func handleCellAction(indexPath: IndexPath)
    
    func removeItem(indexPath: IndexPath)
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    
    private weak var controller: FavoritesViewControllerProtocol?
    
    private var interactor: FavoritesInteractorProtocol
    private var isLoading: Bool
    private var paginator: Paginator?
    
    var dataSource: [Movie] = []
    var flowResult: FlowResult<FavoritesEvent>?
    
    required init(controller: FavoritesViewControllerProtocol, interactor: FavoritesInteractorProtocol) {
        self.controller = controller
        self.interactor = interactor
        self.isLoading = false
    }
    
    private func updateWithLocalFavoriteList() {
        dataSource = interactor.favoritesMovies
        controller?.reloadData()
        controller?.updateBackground(style: dataSource.isEmpty ? .noFavorites : .none)
    }
    
    private func setupPaginator(totalPages: Int) {
        paginator = .init(threshold: 5, totalPages: totalPages)
        paginator?.setPaginationClosure { [weak self] page in
            self?.fetchFavoriteList(page: page)
        }
    }
    
    private func fetchFavoriteList(page: Int, completion: TypeClosure<PageInfo>? = nil) {
        interactor.fetchFavoriteList(page: page) { [weak self] result in
            self?.paginator?.didFinishLoading()
            switch result {
            case .success(let page):
                self?.dataSource += page.movies
                self?.controller?.reloadData()
                completion?(page)
            case .failure:
                self?.paginator = nil
                self?.updateWithLocalFavoriteList()
                self?.cancelLoading()
            }
        }
    }
    
    private func cancelLoading() {
        isLoading = false
        controller?.hideRefreshIndicator()
    }
    
    func fetchFavorites() {
        guard !isLoading else { return }
        dataSource = []
        paginator = nil
        isLoading = true
        fetchFavoriteList(page: 1) { [weak self] page in
            self?.cancelLoading()
            self?.setupPaginator(totalPages: page.totalPages)
        }
    }
    
    func fetchFavoritesIfNeeded(indexPath: IndexPath) {
        let currentIndex = indexPath.row
        let totalItems = dataSource.count
        paginator?.scrollViewDidScroll(currentIndex: currentIndex, totalItems: totalItems)
    }
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard dataSource.indices.contains(indexPath.row) else {
            return nil
        }
        
        let movie = dataSource[indexPath.row]
        let viewModel = MovieTableViewModel(movie: movie)
        return viewModel
    }
    
    func handleCellAction(indexPath: IndexPath) {
        guard dataSource.indices.contains(indexPath.row) else { return }
        let movie = dataSource[indexPath.row]
        flowResult?(.showDetails(id: movie.id))
    }
    
    func removeItem(indexPath: IndexPath) {
        guard dataSource.indices.contains(indexPath.row) else { return }
        let movie = dataSource[indexPath.row]
        interactor.removeFromFavorites(movie: movie) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                dataSource.remove(at: indexPath.row)
                controller?.removeRow(indexPath: indexPath)
            case .failure:
                AlertService.shared.showIcon(.failed)
            }
        }
    }
}
