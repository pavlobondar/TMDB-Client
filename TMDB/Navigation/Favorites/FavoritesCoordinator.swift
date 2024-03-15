//
//  FavoritesCoordinator.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import UIKit

protocol FavoritesCoordinatorProtocol: Coordinator {
    func showFavoritesViewController()
}

final class FavoritesCoordinator: FavoritesCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .genres }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showFavoritesViewController()
    }
    
    func showFavoritesViewController() {
        let networkService = NetworkService()
        let moviesStorage = MoviesRepositoryImpl()
        let favoritesViewController = FavoritesViewController.instantiate()
        let interactor = FavoritesInteractor(networkService: networkService, moviesStorage: moviesStorage)
        let presenter = FavoritesPresenter(controller: favoritesViewController, interactor: interactor)
        favoritesViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .showDetails(let id):
                self?.showDetails(movieId: id)
            }
        }
        navigationController.pushViewController(favoritesViewController, animated: true)
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
            case .showError(let error):
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
extension FavoritesCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
