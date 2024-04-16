//
//  ResetPasswordVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - ResetPasswordVC class

final class ResetPasswordVC: UIViewController {

    // MARK: Properties
    
    private let resetPasswordView = ResetPasswordView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = resetPasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        navigationController?.pushViewController(OneTimeCodeVC(), animated: true)
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    ResetPasswordVC()
}
