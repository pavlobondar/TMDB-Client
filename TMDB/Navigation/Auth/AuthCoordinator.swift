//
//  AuthCoordinator.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation
import UIKit

protocol AuthCoordinatorProtocol: Coordinator {
    func showAuthViewController()
}

final class AuthCoordinator: AuthCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .login }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showAuthViewController()
    }
    
    func showAuthViewController() {
        let networkService = NetworkService()
        let authViewController = AuthViewController.instantiate()
        let interactor = AuthInteractor(networkService: networkService)
        let presenter = AuthPresenter(controller: authViewController, interactor: interactor)
        authViewController.presenter = presenter
        presenter.flowResult = { [weak self] event in
            switch event {
            case .login:
                self?.finish()
            case .showError(let error):
                self?.showError(error)
            }
            
        }
        
        navigationController.pushViewController(authViewController, animated: true)
    }
    
    private func showError(_ error: Error) {
        AlertService.shared.showError(error)
    }
}
