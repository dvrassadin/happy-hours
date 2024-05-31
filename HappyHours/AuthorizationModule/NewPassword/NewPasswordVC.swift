//
//  NewPasswordVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class NewPasswordVC: UIViewController, PasswordChecker, AlertPresenter {

    // MARK: Properties
    
    private lazy var newPasswordView = NewPasswordView()
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
        view = newPasswordView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newPasswordView.endEditing(true)
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
        guard isValidCredentials(),
              let password = newPasswordView.passwordTextField.text,
              let passwordConfirmation = newPasswordView.passwordConfirmationTextField.text
        else { return }
        Task {
            do {
                try await model.setNewPassword(
                    password: password,
                    passwordConfirmation: passwordConfirmation
                )
                navigationController?.popToRootViewController(animated: true)
            } catch {
                showAlert(.settingNewPasswordServerError)
            }
        }
    }
    
    private func isValidCredentials() -> Bool {
        guard let password = newPasswordView.passwordTextField.text,
              isValidPassword(password),
              let passwordConfirmation = newPasswordView.passwordConfirmationTextField.text,
              isValidPassword(passwordConfirmation)
        else {
            showAlert(.invalidPasswordLength)
            return false
        }
        
        guard password == passwordConfirmation else {
            showAlert(.notMatchPasswords)
            return false
        }
        
        return true
    }
    
}
