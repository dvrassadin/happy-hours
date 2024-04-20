//
//  UIWindow+Navigation.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/4/24.
//

import UIKit

// MARK: - LogInDelegate

extension UIWindow: LogInDelegate {
    
    func logIn() {
        let mainVC = MainTabBarController()
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.setViewControllers([mainVC], animated: true)
            
        } else {
            rootViewController = mainVC
        }
    }
    
}

// MARK: - LogOutDelegate

extension UIWindow: LogOutDelegate {
    
    func logOut() {
        let signInVC = SignInVC()
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.setViewControllers([signInVC], animated: true)
        } else {
            rootViewController = signInVC
        }
    }
    
}
