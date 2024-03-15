//
//  SearchPresenter.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol SearchPresenterProtocol {
    var dataSource: SearchSection { get }
    
    func searchMovies(query: String)
    func fetchMoviesIfNeeded(query: String, indexPath: IndexPath)
    func cancelSearch()
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel?
    func handleCellAction(indexPath: IndexPath)
    func searchTextDidChange(text: String)
    
    func removeItem(indexPath: IndexPath)
    func addToFavorites(indexPath: IndexPath)
}

final class SearchPresenter: SearchPresenterProtocol {
    
    private let numberOfSuggestions: Int
    
    private weak var controller: SearchViewControllerProtocol?
    
    private var interactor: SearchInteractorProtocol
    private var paginator: Paginator?
    
    var dataSource: SearchSection
    var flowResult: FlowResult<SearchEvent>?
    
    required init(controller: SearchViewControllerProtocol, interactor: SearchInteractorProtocol) {
        self.numberOfSuggestions = 10
        self.controller = controller
        self.interactor = interactor
        self.dataSource = .init(type: .recentSearches, items: [])
        
        updateSearchSuggestions()
    }
    
    private func updateSearchSuggestions() {
        let isSuggestionsEmpty = interactor.searchSuggestions.isEmpty
        if !isSuggestionsEmpty {
            let viewModels = interactor.getFirstSearchSuggestions(numberOfSuggestions).map {
                RecentSearchTableViewModel(suggestion: $0)
            }
            dataSource = .init(type: .recentSearches, items: viewModels)
        }
        controller?.updateBackground(style: isSuggestionsEmpty ? .noSearches : .none)
        controller?.reloadData()
    }
    
    private func setupPaginator(totalPages: Int) {
        paginator = .init(threshold: 5, totalPages: totalPages)
        paginator?.setPaginationClosure { [weak self] page in
            self?.fetchMovies(page: page)
        }
    }
    
    private func showBackgroundError(_ error: Error) {
        guard var error = error as? RESTError, error == .noInternetConnection, dataSource.items.isEmpty else {
            controller?.updateBackground(style: .none)
            return
        }
        controller?.updateBackground(style: .networkError)
    }
    
    private func fetchMovies(page: Int, totalPagesHandler: TypeClosure<Int>? = nil) {
        switch dataSource.type {
        case .movies(let query):
            interactor.fetchMovies(query: query, page: page) { [weak self] result in
                switch result {
                case .success(let pageInfo):
                    let movies = pageInfo.movies.filter { $0.backdropPath != nil || $0.posterPath != nil }
                    self?.dataSource.items += movies.map { MovieTableViewModel(movie: $0) }
                    self?.paginator?.didFinishLoading()
                    self?.controller?.reloadData()
                    totalPagesHandler?(pageInfo.totalPages)
                case .failure(let error):
                    self?.showBackgroundError(error)
                    self?.flowResult?(.showError(error: error))
                }
            }
        case .recentSearches:
            break
        }
    }
    
    private func filterSuggestions(text: String) -> [RecentSearch] {
        guard text.isEmpty else {
            let options = NSString.CompareOptions.caseInsensitive
            let filteredSuggestions = interactor.searchSuggestions.filter {
                let suggestion = $0.query.range(of: text, options: options)
                return suggestion != nil
            }
            return filteredSuggestions
        }
        return interactor.getFirstSearchSuggestions(numberOfSuggestions)
    }
    
    func searchMovies(query: String) {
        interactor.saveQuery(query)
        dataSource.type = .movies(query: query)
        dataSource.items = []
        paginator = nil
        controller?.updateBackground(style: .none)
        fetchMovies(page: 1) { [weak self] totalPages in
            self?.setupPaginator(totalPages: totalPages)
        }
    }
    
    func fetchMoviesIfNeeded(query: String, indexPath: IndexPath) {
        switch dataSource.type {
        case .movies:
            let currentIndex = indexPath.row
            let totalItems = dataSource.items.count
            paginator?.scrollViewDidScroll(currentIndex: currentIndex, totalItems: totalItems)
        case .recentSearches:
            break
        }
    }
    
    func cancelSearch() {
        dataSource.items = []
        updateSearchSuggestions()
    }
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard dataSource.items.indices.contains(indexPath.row) else {
            return nil
        }
        
        let viewModel = dataSource.items[indexPath.row]
        return viewModel
    }
    
    func handleCellAction(indexPath: IndexPath) {
        guard dataSource.items.indices.contains(indexPath.row) else {
            return
        }
        
        let viewModel = dataSource.items[indexPath.row]
        switch dataSource.type {
        case .recentSearches:
            guard let viewModel = viewModel as? RecentSearchTableViewModel else { return }
            let query = viewModel.suggestion.query
            searchMovies(query: query)
            controller?.setSearchQuery(query)
        case .movies:
            guard let viewModel = viewModel as? MovieTableViewModel else { return }
            let movie = viewModel.movie
            flowResult?(.showDetails(id: movie.id))
        }
    }
    
    func searchTextDidChange(text: String) {
        switch dataSource.type {
        case .recentSearches:
            let filteredSuggestions: [RecentSearch] = filterSuggestions(text: text)
            dataSource.items = filteredSuggestions.map { RecentSearchTableViewModel(suggestion: $0) }
            controller?.reloadData()
        case .movies:
            break
        }
    }
    
    func removeItem(indexPath: IndexPath) {
        guard dataSource.items.indices.contains(indexPath.row) else {
            return
        }
        
        let viewModel = dataSource.items[indexPath.row]
        switch dataSource.type {
        case .recentSearches:
            guard let viewModel = viewModel as? RecentSearchTableViewModel else { return }
            let suggestion = viewModel.suggestion
            interactor.removeSuggestion(uuid: suggestion.uuid) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    dataSource.items.remove(at: indexPath.row)
                    controller?.removeRow(indexPath: indexPath)
                    controller?.updateBackground(style: dataSource.items.isEmpty ? .networkError : .none)
                case .failure(let error):
                    flowResult?(.showError(error: error))
                }
            }
        case .movies:
            break
        }
    }
    
    func addToFavorites(indexPath: IndexPath) {
        guard dataSource.items.indices.contains(indexPath.row) else {
            return
        }
        
        let viewModel = dataSource.items[indexPath.row]
        switch dataSource.type {
        case .movies:
            guard let viewModel = viewModel as? MovieTableViewModel else { return }
            let movie = viewModel.movie
            interactor.addMovieToFavorites(movie) { result in
                switch result {
                case .success:
                    AlertService.shared.showIcon(.succeed)
                case .failure:
                    AlertService.shared.showIcon(.failed)
                }
            }
        case .recentSearches:
            break
        }
    }
}
