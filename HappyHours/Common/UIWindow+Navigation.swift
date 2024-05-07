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
        guard let networkService = (windowScene?.delegate as? SceneDelegate)?.networkService else {
            return
        }
        let mainVC = MainTabBarController(networkService: networkService)
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
        guard let networkService = (windowScene?.delegate as? SceneDelegate)?.networkService else {
            return
        }
        
        let signInModel = AuthorizationModel(networkService: networkService)
        let signInVC = SignInVC(model: signInModel)
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.setViewControllers([signInVC], animated: true)
        } else {
            rootViewController = signInVC
        }
        isLoggedIn = false
    }
    
}
