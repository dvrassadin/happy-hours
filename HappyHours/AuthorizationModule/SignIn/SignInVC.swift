//
//  SignInVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/4/24.
//

import UIKit

final class SignInVC: UIViewController {
    
    // MARK: Properties
    
    private let signInView = SignInView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - SignUpStackViewDelegate

extension SignInVC: SignUpStackViewDelegate {
    
    func goToSignUp() {
        print("Sign up button pressed")
    }
    
}
