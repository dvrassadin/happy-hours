//
//  SignInVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

// MARK: - SignInVC class

/// This class is made for the first logging in were user can enter the email and password, reset the password or sign up
final class SignInVC: UIViewController {
    
    // MARK: Properties
    
    private let signInView = SignInView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInView.resetButton.addTarget(
            self,
            action: #selector(goToResetPasswordVC),
            for: .touchUpInside
        )
    }
    
    // MARK: User interaction
    
    @objc private func goToResetPasswordVC() {
        print("Reset Password button pressed")
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
