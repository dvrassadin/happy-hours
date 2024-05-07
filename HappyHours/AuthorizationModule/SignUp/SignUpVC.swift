//
//  SignUpVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

// MARK: - SignUpVC class

final class SignUpVC: UIViewController, NameChecker, EmailChecker, PasswordChecker, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var signUpView = SignUpView()
    private let model: AuthorizationModelProtocol

    // MARK: Lifecycle
    
    init(model: AuthorizationModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        guard let name = signUpView.nameTextField.text else {
            showAlert(.emptyName)
            return
        }
        
        guard isValidName(name) else {
            showAlert(.invalidName)
            return
        }
        
        guard let email = signUpView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return
        }
        
        guard let password = signUpView.passwordTextField.text,
              isValidPassword(password),
              let passwordConfirm = signUpView.confirmPasswordTextField.text,
              isValidPassword(passwordConfirm)
        else {
            showAlert(.invalidPasswordLength)
            return
        }
        
        guard password == passwordConfirm else {
            showAlert(.notMatchPasswords)
            return
        }
        
        signUpView.isCreatingAccount = true
        Task {
            do {
                try await model.createUser(
                    email: email,
                    password: password,
                    passwordConfirm: passwordConfirm,
                    name: name,
                    date: signUpView.datePicker.date
                )
                signUpView.isCreatingAccount = false
                showAlert(.accountCreated) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogInDelegate.logIn),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                signUpView.isCreatingAccount = false
                showAlert(.createUserServerError, message: error.localizedDescription)
            }
        }
    }
    
    private func isValidCredentials() -> Bool {
        guard let name = signUpView.nameTextField.text else {
            showAlert(.emptyName)
            return false
        }
        
        guard isValidName(name) else {
            showAlert(.invalidName)
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
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    SignUpVC(model: AuthorizationModel(networkService: NetworkService()))
}
