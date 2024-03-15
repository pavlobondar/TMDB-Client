//
//  AuthViewController.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerProtocol: AnyObject {
    func showActivityIndicator()
    func hideActivityIndicator()
    func showMessage(title: String, message: String)
}

final class AuthViewController: UIViewController {
    @IBOutlet private weak var containerView: UIVisualEffectView!
    
    @IBOutlet private weak var usernameTextField: RoundedTextField!
    @IBOutlet private weak var passwordTextField: RoundedTextField!
    
    @IBOutlet private weak var loginButton: RoundedButton!
    
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    var presenter: AuthPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        setupViewTapGesture()
        setupContainerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func getKeyboardData(_ notification: NSNotification) -> (keyboardSize: NSValue, keyboardDuration: Double)? {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return nil
        }
        return (keyboardSize, keyboardDuration)
    }
    
    private func setupViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupContainerView() {
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 18.0)
    }
    
    private func login() {
        let login = usernameTextField.text!
        let password = passwordTextField.text!
        presenter?.signIn(login: login, password: password)
    }
    
    @IBAction private func loginButtonAction(_ sender: RoundedButton) {
        login()
        hideKeyboard()
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardData = getKeyboardData(notification), bottomConstraint.constant == 40 else { return }
        let keyboardHeight = keyboardData.keyboardSize.cgRectValue.height
        UIView.animate(withDuration: keyboardData.keyboardDuration, delay: 0.0) { [weak self] in
            self?.bottomConstraint.constant = keyboardHeight
        }
        view.layoutIfNeeded()
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        guard let keyboardData = getKeyboardData(notification) else { return }
        UIView.animate(withDuration: keyboardData.keyboardDuration, delay: 0.0) { [weak self] in
            self?.bottomConstraint.constant = 40
        }
        view.layoutIfNeeded()
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login()
            hideKeyboard()
        }
        return false
    }
}

// MARK: - AuthViewControllerProtocol
extension AuthViewController: AuthViewControllerProtocol {
    func showActivityIndicator() {
        ProgressHUD.animate(nil, .circleStrokeSpin)
        loginButton.isEnabled = false
    }
    
    func hideActivityIndicator() {
        ProgressHUD.dismiss()
        loginButton.isEnabled = true
    }
    
    func showMessage(title: String, message: String) {
        ProgressHUD.banner(title, message, delay: 3.5)
    }
}
