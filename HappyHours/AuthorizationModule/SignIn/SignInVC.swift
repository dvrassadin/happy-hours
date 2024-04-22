//
//  SignInVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

// MARK: - SignInVC class

/// This class is made for the first logging in were user can enter the email and password, reset the password or sign up
final class SignInVC: AuthViewController, EmailChecker, PasswordChecker {
    
    // MARK: Properties
    
    private let signInView = SignInView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        signInView.resetButton.addTarget(
            self,
            action: #selector(goToResetPasswordVC),
            for: .touchUpInside
        )
        signInView.logInButton.addTarget(
            self,
            action: #selector(goToMainModule),
            for: .touchUpInside
        )
    }
    
    @objc private func goToMainModule() {
        guard isValidCredentials() else { return }
        
        UIApplication.shared.sendAction(
            #selector(LogInDelegate.logIn),
            to: nil,
            from: self,
            for: nil
        )
    }
    
    @objc private func goToResetPasswordVC() {
        navigationController?.pushViewController(ResetPasswordVC(), animated: true)
    }
    
    private func isValidCredentials() -> Bool {
        guard let email = signInView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return false
        }
        
        guard let password = signInView.passwordTextField.text, isValidPassword(password) else {
            showAlert(.invalidPasswordLength)
            return false
        }
        
        return true
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    SignInVC()
}

// MARK: - SignUpStackViewDelegate

extension SignInVC: SignUpStackViewDelegate {
    
    func goToSignUp() {
        navigationController?.pushViewController(SignUpVC(), animated: true)
    }
    
}
