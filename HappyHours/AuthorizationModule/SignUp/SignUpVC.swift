//
//  SignUpVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

// MARK: - SignUpVC class

final class SignUpVC: UIViewController {
    
    // MARK: Properties
    
    private let signUpView = SignUpView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView.createAccountButton.addTarget(
            self,
            action: #selector(createAccount),
            for: .touchUpInside
        )
    }
    
    // MARK: User interaction
    
    @objc private func createAccount() {
        print("Create Account button pressed")
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    SignUpVC()
}
