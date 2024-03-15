//
//  SearchCoordinator.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import UIKit

protocol SearchCoordinatorProtocol: Coordinator {
    func showSearchViewController()
}

final class SearchCoordinator: SearchCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .genres }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSearchViewController()
    }
    
    func showSearchViewController() {
        let networkService = NetworkService()
        let recentSearchStorage = RecentSearchRepositoryImpl()
        let moviesStorage = MoviesRepositoryImpl()
        let searchViewController = SearchViewController.instantiate()
        let interactor = SearchInteractor(networkService: networkService, recentSearchStorage: recentSearchStorage, moviesStorage: moviesStorage)
        let presenter = SearchPresenter(controller: searchViewController, interactor: interactor)
        searchViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .showDetails(let id):
                self?.showDetails(movieId: id)
            case .showError(error: let error):
                self?.showError(error)
            }
        }
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    private func showDetails(movieId: Int) {
        let networkService = NetworkService()
        let moviesStorage = MoviesRepositoryImpl()
        let detailsViewController = DetailsViewController.instantiate()
        let interactor = DetailsInteractor(networkService: networkService, moviesStorage: moviesStorage)
        let presenter = DetailsPresenter(movieId: movieId, controller: detailsViewController, interactor: interactor)
        detailsViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .back:
                self?.popViewController()
            case .openPage(let url):
                self?.openInSafari(pageURL: url)
            case .share(let url):
                self?.openActivityViewController(pageURL: url)
            case .showError(error: let error):
                self?.showError(error)
            }
        }
        
        detailsViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    private func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    private func openInSafari(pageURL: String) {
        guard let url = URL(string: pageURL) else { return }
        UIApplication.shared.open(url)
    }
    
    private func openActivityViewController(pageURL: String) {
        guard let url = URL(string: pageURL) else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        navigationController.present(activityController, animated: true)
    }
    
    private func showError(_ error: Error) {
        AlertService.shared.showError(error)
    }
}

// MARK: - CoordinatorFinishDelegate
extension SearchCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
