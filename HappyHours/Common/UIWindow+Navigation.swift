//
//  UIWindow+Navigation.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/4/24.
//

import UIKit

// MARK: - Properties

extension UIWindow {
    var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
        set { UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn") }
    }
}

// MARK: - LogInDelegate

extension UIWindow: LogInDelegate {
    
    func logIn() {
        let mainVC = MainTabBarController()
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.setViewControllers([mainVC], animated: true)
        } else {
            rootViewController = mainVC
        }
        isLoggedIn = true
    }
    
}

// MARK: - LogOutDelegate

extension UIWindow: LogOutDelegate {
    
    func logOut() {
        let signInModel = AuthorizationModel(networkService: NetworkService())
        let signInVC = SignInVC(model: signInModel)
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.setViewControllers([signInVC], animated: true)
        } else {
            rootViewController = signInVC
        }
        isLoggedIn = false
    }
    
}
