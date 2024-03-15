//
//  AuthPresenter.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import Foundation

protocol AuthPresenterProtocol {
    func signIn(login: String, password: String)
}

final class AuthPresenter: AuthPresenterProtocol {
    
    weak var controller: AuthViewControllerProtocol?
    
    var interactor: AuthInteractorProtocol
    var flowResult: FlowResult<AuthEvent>?
    
    required init(controller: AuthViewControllerProtocol, interactor: AuthInteractorProtocol) {
        self.controller = controller
        self.interactor = interactor
    }
    
    func signIn(login: String, password: String) {
        guard !login.isEmpty && !password.isEmpty else {
            controller?.showMessage(title: "Validation error", message: "Verify your credentials!")
            return
        }
        
        controller?.showActivityIndicator()
        interactor.login(username: login, password: password) { [weak self] result in
            self?.controller?.hideActivityIndicator()
            switch result {
            case .success:
                self?.flowResult?(.login)
            case .failure(let error):
                self?.flowResult?(.showError(error: error))
            }
        }
    }
}
