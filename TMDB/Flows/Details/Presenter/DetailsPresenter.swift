//
//  DetailsPresenter.swift
//  TMDB
//
//  Created by Pavlo on 25.01.2024.
//

import Foundation

protocol DetailsPresenterProtocol {
    var title: String? { get }
    var dataSource: [DetailSection] { get }
    
    func fetchMovieDetails()
    
    func getHeaderViewModel(indexPath: IndexPath) -> HeaderViewModel?
    func getViewModel(indexPath: IndexPath) -> CellViewModel?
    
    func dismiss()
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    private weak var controller: DetailsViewControllerProtocol?
        
    private var movieId: Int
    private var isFavorite: Bool
    private var interactor: DetailsInteractorProtocol
    private var movieDetails: MovieDetails?
    
    var title: String?
    var dataSource: [DetailSection] = []
    var flowResult: FlowResult<DetailsEvent>?
    
    required init(movieId: Int, controller: DetailsViewControllerProtocol, interactor: DetailsInteractorProtocol) {
        self.movieId = movieId
        self.isFavorite = interactor.isFavoriteMovie(id: movieId)
        self.controller = controller
        self.interactor = interactor
    }
    
    private func generateSections() {
        guard let movie = movieDetails else { return }
        
        let posters = movie.getImages(type: .poster)
        let companies = movie.productionCompanies
        let trailers = movie.videos.videos
        let images = movie.getImages(type: .backdrops)
        let cast = movie.credits.cast.filter { $0.profilePath != nil }
        let languages = movie.spokenLanguages.map { $0.englishName }.joined(separator: ", ")
        let crew = movie.credits.crew.map { $0.name }.joined(separator: ", ")
        let similar = movie.similar.movies.filter { $0.backdropImageURL != nil && $0.posterURL != nil }
        
        dataSource = [.init(type: .overview, items: [OverviewCellViewModel(movie: movie)])]
            
        let additionalInfo: [DetailSection] = [
            .init(type: .cast, items: cast.map { CastCellViewModel(cast: $0) }),
            .init(type: .trailers, items: trailers.map { TrailerCellViewModel(video: $0) }),
            .init(type: .companies, items: companies.map { CompanyCellViewModel(company: $0) }),
            .init(type: .posters, items: posters.map { PosterCellViewModel(movieImage: $0) }),
            .init(type: .similar, items: similar.map { MovieCellViewModel(movie: $0) }),
            .init(type: .languages, items: [TextCellViewModel(info: .init(title: languages, subtitle: nil))]),
            .init(type: .crew, items: [TextCellViewModel(info: .init(title: nil, subtitle: crew))])
        ].filter {
            !$0.items.isEmpty
        }
        
        dataSource.append(contentsOf: additionalInfo)
        
        let bgImages = images.isEmpty ? posters : images
        interactor.fetchImages(models: bgImages) { [weak self] images in
            self?.controller?.hideProgressIndicator()
            self?.controller?.setBackgroundImages(images: images)
            self?.controller?.reloadData()
        }
    }
    
    private func getSectionIndex(type: DetailSectionType) -> Int? {
        guard let sectionIndex = dataSource.firstIndex(where: { $0.type == type }) else {
            return nil
        }
        return sectionIndex
    }
    
    private func updateMovieStatus() {
        guard let movieDetails = movieDetails else { return }
        let movie = Movie(movieDetails: movieDetails)
        controller?.showProgressIndicator()
        interactor.updateFavoriteStatus(movie, isFavorite: isFavorite) { [weak self] result in
            self?.controller?.hideProgressIndicator()
            switch result {
            case .success(let isFavorite):
                guard let sectionIndex = self?.getSectionIndex(type: .overview) else { return }
                self?.isFavorite = isFavorite
                self?.controller?.updateSection(index: sectionIndex)
            case .failure(let error):
                self?.flowResult?(.showError(error: error))
            }
        }
    }
    
    private func showBackgroundError(_ error: Error) {
        if let error = error as? RESTError, error == .noInternetConnection {
            controller?.updateBackground(style: .networkError)
        } else {
            controller?.updateBackground(style: .error)
        }
    }
        
    func fetchMovieDetails() {
        controller?.showProgressIndicator()
        interactor.fetchMovieDetails(id: movieId) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                self?.movieDetails = movieDetails
                self?.title = movieDetails.title
                self?.generateSections()
                self?.controller?.updateBackground(style: .none)
            case .failure(let error):
                self?.controller?.hideProgressIndicator()
                self?.showBackgroundError(error)
                self?.flowResult?(.showError(error: error))
            }
        }
    }
    
    func getHeaderViewModel(indexPath: IndexPath) -> HeaderViewModel? {
        guard dataSource.indices.contains(indexPath.section) else {
            return nil
        }
        
        let sectionType = dataSource[indexPath.section].type
        switch sectionType {
        case .overview:
            guard let movie = movieDetails else { return nil }
            let viewModel = OverviewCollectionHeaderViewModel(movie: movie, isFavorite: isFavorite)
            viewModel.actionHandler = { [weak self] action in
                switch action {
                case .updateFavoriteStatus:
                    self?.updateMovieStatus()
                case .share:
                    self?.flowResult?(.share(url: movie.homepage))
                case .openLink:
                    break
                }
            }
            return viewModel
        case .trailers, .companies, .posters, .cast, .languages, .crew, .similar:
            let viewModel = DetailsCollectionHeaderViewModel(section: sectionType)
            return viewModel
        }
    }
    
    func getViewModel(indexPath: IndexPath) -> CellViewModel? {
        guard dataSource.indices.contains(indexPath.section),
              dataSource[indexPath.section].items.indices.contains(indexPath.item) else {
            return nil
        }
        
        let section = dataSource[indexPath.section]
        let viewModel = section.items[indexPath.item]
        switch section.type {
        case .overview:
            guard let viewModel = viewModel as? OverviewCellViewModel, let movie = movieDetails else { return nil }
            viewModel.actionHandler = { [weak self] action in
                switch action {
                case .openLink:
                    self?.flowResult?(.openPage(url: movie.homepage))
                case .updateFavoriteStatus, .share:
                    break
                }
            }
            return viewModel
        case .trailers, .companies, .posters, .cast, .languages, .crew, .similar:
            return viewModel
        }
    }
    
    func dismiss() {
        flowResult?(.back)
    }
}
