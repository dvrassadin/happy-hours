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

    // MARK: Lifecycle
    
    override func loadView() {
        view = resetPasswordView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavigation()
        resetPasswordView.emailTextField.becomeFirstResponder()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        resetPasswordView.continueButton.addTarget(
            self,
            action: #selector(goToOTPVC),
            for: .touchUpInside
        )
    }
    
    @objc private func goToOTPVC() {
        guard isValidCredentials() else { return }
        navigationController?.pushViewController(OneTimeCodeVC(), animated: true)
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
    ResetPasswordVC()
}
