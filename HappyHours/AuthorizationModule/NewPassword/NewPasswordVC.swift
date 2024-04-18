//
//  NewPasswordVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class NewPasswordVC: AuthViewController, PasswordChecker {

    // MARK: Properties
    
    private let newPasswordView = NewPasswordView()
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = newPasswordView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigation()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        newPasswordView.createButton.addTarget(
            self,
            action: #selector(goToSignInVC),
            for: .touchUpInside
        )
    }
    
    @objc private func goToSignInVC() {
        guard isValidCredentials() else { return }
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func isValidCredentials() -> Bool {
        guard let firstPassword = newPasswordView.passwordTextField.text,
              isValidPassword(firstPassword),
              let secondPassword = newPasswordView.confirmPasswordTextField.text,
              isValidPassword(secondPassword)
        else {
            showAlert(.invalidPasswordLength)
            return false
        }
        
        guard firstPassword == secondPassword else {
            showAlert(.notMatchPasswords)
            return false
        }
        
        return true
    }
    
}
