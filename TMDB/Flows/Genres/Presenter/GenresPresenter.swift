//
//  GenresPresenter.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol GenresPresenterProtocol {
    var dataSource: [MovieSection] { get }
    
    func fetchMovies()
    
    func getHeaderViewModel(indexPath: IndexPath) -> HeaderViewModel?
    func getViewModel(indexPath: IndexPath) -> CellViewModel?
    func showMovieDetails(indexPath: IndexPath)
    
    func logout()
}

final class GenresPresenter: GenresPresenterProtocol {
    
    private weak var controller: GenresViewControllerProtocol?
    
    private let genres: [Genre] = [.action, .drama, .fantasy, .western, .dokumentarfilm, .animation, .horror, .mystery]
    private let moviePage = 1
    
    private var interactor: GenresInteractorProtocol
    
    var flowResult: FlowResult<GenresEvent>?
    var dataSource: [MovieSection] = []
    
    required init(controller: GenresViewControllerProtocol, interactor: GenresInteractorProtocol) {
        self.controller = controller
        self.interactor = interactor
    }
    
    private func deleteCurrentSession() {
        interactor.deleteSession() { [weak self] result in
            switch result {
            case .success:
                self?.flowResult?(.finish)
            case .failure(let error):
                self?.flowResult?(.showError(error: error))
            }
        }
    }
    
    func fetchMovies() {
        controller?.showProgressIndicator()
        interactor.fetchMovieLists(genres: genres, page: moviePage) { [weak self] result in
            self?.controller?.hideProgressIndicator()
            switch result {
            case .success(let movieLists):
                if movieLists.flatMap({ $0.page.movies }).isEmpty {
                    self?.controller?.updateBackground(style: .error)
                } else {
                    self?.dataSource = movieLists
                    self?.controller?.updateBackground(style: .none)
                    self?.controller?.reloadData()
                }
            case .failure:
                self?.controller?.updateBackground(style: .networkError)
            }
        }
    }
    
    func getHeaderViewModel(indexPath: IndexPath) -> HeaderViewModel? {
        guard dataSource.indices.contains(indexPath.section) else {
            return nil
        }
        
        let movieList = dataSource[indexPath.section]
        let headerType = movieList.type
        switch headerType {
        case .popular:
            let numberOfPages = movieList.page.movies.count
            let viewModel = PopularCollectionHeaderViewModel(numberOfPages: numberOfPages, currentPage: 0)
            return viewModel
        case .regular:
            guard let genre = movieList.genre else { return nil }
            let viewModel = GenreCollectionHeaderViewModel(genre: genre)
            viewModel.actionHandler = { [weak self] in
                self?.flowResult?(.showList(movieList: movieList))
            }
            return viewModel
        }
    }
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard dataSource.indices.contains(indexPath.section),
              dataSource[indexPath.section].page.movies.indices.contains(indexPath.item) else {
            return nil
        }
        
        let listType = dataSource[indexPath.section].type
        let movie = dataSource[indexPath.section].page.movies[indexPath.item]
        switch listType {
        case .popular:
            let viewModel = PopularMovieCellViewModel(movie: movie)
            return viewModel
        case .regular:
            let viewModel = MovieCellViewModel(movie: movie)
            return viewModel
        }
    }
    
    func showMovieDetails(indexPath: IndexPath) {
        guard dataSource.indices.contains(indexPath.section),
              dataSource[indexPath.section].page.movies.indices.contains(indexPath.item) else {
            return
        }
        
        let movie = dataSource[indexPath.section].page.movies[indexPath.item]
        flowResult?(.showDetails(id: movie.id))
    }
    
    func logout() {
        flowResult?(.showLogoutWarning() { [weak self] in
            self?.deleteCurrentSession()
        })
    }
}
