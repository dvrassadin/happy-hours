//
//  AuthViewController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: Alerts
    
    enum AlertType {
        case invalidEmail, invalidPasswordLength, notMatchPasswords, accountCreated, emptyName
    }
    
    func showAlert(_ type: AlertType) {
        let message: String
        let title: String
        
        switch type {
        case .invalidEmail:
            title = String(localized: "Invalid Email")
            message = String(localized: "This email address is not valid.\nEnter a different address.")
        case .invalidPasswordLength:
            title = String(localized: "Invalid Password")
            message = String(localized: "This password is too short.\nPasswords are 8 and more characters long.")
        case .notMatchPasswords:
            title = String(localized: "Passwords do not Match")
            message = String(localized: "Enter your new passwords again.")
        case .emptyName:
            title = String(localized: "Empty Name")
            message = String(localized: "Please, enter your name.")
        case .accountCreated:
            title = String(localized: "Success")
            message = String(localized: "Your account was created. Enter your email and password to sign in.")
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
}
