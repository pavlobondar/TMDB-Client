//
//  ListPresenter.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import Foundation

protocol ListPresenterProtocol {
    var dataSource: MovieSection { get }
    
    func fetchMoviesIfNeeded(indexPath: IndexPath)
    func getViewModel(indexPath: IndexPath) -> CellViewModel?
    func showDetails(indexPath: IndexPath)
    
    func addToFavorites(indexPath: IndexPath)
}

final class ListPresenter: ListPresenterProtocol {
    
    private weak var controller: ListViewControllerProtocol?
    
    private var interactor: ListInteractorProtocol
    private var paginator: Paginator
    
    var dataSource: MovieSection
    var flowResult: FlowResult<ListEvent>?
    
    required init(movieList: MovieSection, controller: ListViewControllerProtocol, interactor: ListInteractorProtocol) {
        self.dataSource = movieList
        self.controller = controller
        self.interactor = interactor
        self.paginator = .init(threshold: 5, totalPages: movieList.page.totalPages)
        setupPaginator()
    }
    
    private func setupPaginator() {
        paginator.setPaginationClosure { [weak self] page in
            self?.fetchMovies(page: page)
        }
    }
    
    private func fetchMovies(page: Int) {
        guard let genre = dataSource.genre else { return }
        interactor.fetchMovies(genre: genre, page: page) { [weak self] movieLists in
            let movies = movieLists.flatMap { $0.page.movies }
            self?.dataSource.page.movies.append(contentsOf: movies)
            self?.paginator.didFinishLoading()
            self?.controller?.reloadData()
        }
    }
    
    func fetchMoviesIfNeeded(indexPath: IndexPath) {
        let currentIndex = indexPath.row
        let totalItems = dataSource.page.movies.count
        paginator.scrollViewDidScroll(currentIndex: currentIndex, totalItems: totalItems)
    }
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard dataSource.page.movies.indices.contains(indexPath.row) else {
            return nil
        }
        
        let movie = dataSource.page.movies[indexPath.row]
        let viewModel = MovieTableViewModel(movie: movie)
        return viewModel
    }
    
    func showDetails(indexPath: IndexPath) {
        guard dataSource.page.movies.indices.contains(indexPath.row) else {
            return
        }
        
        let movie = dataSource.page.movies[indexPath.row]
        flowResult?(.showDetails(id: movie.id))
    }
    
    func addToFavorites(indexPath: IndexPath) {
        guard dataSource.page.movies.indices.contains(indexPath.row) else {
            return
        }
        
        let movie = dataSource.page.movies[indexPath.row]
        interactor.addMovieToFavorites(movie) { result in
            switch result {
            case .success:
                AlertService.shared.showIcon(.succeed)
            case .failure:
                AlertService.shared.showIcon(.failed)
            }
        }
    }
}
