//
//  ResetPasswordVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - ResetPasswordVC class

final class ResetPasswordVC: UIViewController, EmailChecker, AlertPresenter {

    // MARK: Properties
    
    private lazy var resetPasswordView = ResetPasswordView()
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
        view = resetPasswordView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigation()
        resetPasswordView.emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetPasswordView.endEditing(true)
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        resetPasswordView.continueButton.addTarget(
            self,
            action: #selector(goToOTCVC),
            for: .touchUpInside
        )
    }
    
    @objc private func goToOTCVC() {
        guard isValidCredentials(), let email = resetPasswordView.emailTextField.text else {
            return
        }
        
        Task {
            do {
                try await model.sendEmailForOTC(String(email.lowercased()))
                navigationController?.pushViewController(
                    OneTimeCodeVC(model: model),
                    animated: true
                )
            } catch {
                showAlert(.sendingEmailServerError)
            }
        }
    }
    
    private func isValidCredentials() -> Bool {
        guard let email = resetPasswordView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return false
        }
        
        return true
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    ResetPasswordVC(
        model: AuthorizationModel(
            networkService: NetworkService(
                authService: AuthService(keyChainService: KeyChainService())
            )
        )
    )
    
}
