//
//  GenresCoordinator.swift
//  TMDB
//
//  Created by Pavlo on 28.01.2024.
//

import UIKit

protocol GenresCoordinatorProtocol: Coordinator {
    func showGenresViewController()
}

final class GenresCoordinator: GenresCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .genres }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showGenresViewController()
    }
    
    func showGenresViewController() {
        let networkService = NetworkService()
        let genresViewController = GenresViewController.instantiate()
        let interactor = GenresInteractor(networkService: networkService)
        let presenter = GenresPresenter(controller: genresViewController, interactor: interactor)
        genresViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .showList(let movieList):
                self?.showList(movieList: movieList)
            case .showDetails(let id):
                self?.showDetails(movieId: id)
            case .showLogoutWarning(let acceptHandler):
                self?.showLogoutWarningAlert(acceptHandler: acceptHandler)
            case .showError(let error):
                self?.showError(error)
            case .finish:
                self?.finish()
            }
        }
        navigationController.pushViewController(genresViewController, animated: true)
    }
    
    private func showList(movieList: MovieSection) {
        let networkService = NetworkService()
        let moviesStorage = MoviesRepositoryImpl()
        let listViewController = ListViewController.instantiate()
        let interactor = ListInteractor(networkService: networkService, moviesStorage: moviesStorage)
        let presenter = ListPresenter(movieList: movieList, controller: listViewController, interactor: interactor)
        listViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .showDetails(let id):
                self?.showDetails(movieId: id)
            }
        }
        
        listViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(listViewController, animated: true)
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
    
    private func showLogoutWarningAlert(acceptHandler: VoidClosure? = nil) {
        let title = "Warning"
        let message = "Are you sure you want to log out?"
        let acceptTitle = "Log out"
        
        let warningAlertView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        warningAlertView.addAction(.init(title: acceptTitle, style: .destructive) { _ in
            acceptHandler?()
        })
        warningAlertView.addAction(.init(title: "Cancel", style: .cancel))
        
        navigationController.present(warningAlertView, animated: true)
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
    
    private func popViewController() {
        navigationController.popViewController(animated: true)
    }
}


// MARK: - CoordinatorFinishDelegate
extension GenresCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
