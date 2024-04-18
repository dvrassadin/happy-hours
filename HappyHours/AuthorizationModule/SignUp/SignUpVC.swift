//
//  SignUpVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

// MARK: - SignUpVC class

final class SignUpVC: AuthViewController, EmailChecker, PasswordChecker {
    
    // MARK: Properties
    
    private let signUpView = SignUpView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigation()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        signUpView.createAccountButton.addTarget(
            self,
            action: #selector(createAccount),
            for: .touchUpInside
        )
    }
    
    @objc private func createAccount() {
        guard isValidCredentials() else { return }
        showAlert(.accountCreated) { _ in 
            // TODO: Make navigation without back button
            self.navigationController?.pushViewController(MainTabBarController(), animated: true)
        }
    }
    
    private func isValidCredentials() -> Bool {
        guard isValidName() else {
            showAlert(.emptyName)
            return false
        }
        
        guard let email = signUpView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return false
        }
        
        guard let firstPassword = signUpView.passwordTextField.text,
              isValidPassword(firstPassword),
              let secondPassword = signUpView.confirmPasswordTextField.text,
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
    
    private func isValidName() -> Bool {
        guard let name = signUpView.nameTextField.text else { return false }
        return !name.isEmpty
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    SignUpVC()
}
