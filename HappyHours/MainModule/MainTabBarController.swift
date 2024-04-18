//
//  MainTabBarController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        view.backgroundColor = .Custom.background
        tabBar.tintColor = .Custom.primary
        setUpTabs()
    }
    
    private func setUpTabs() {
        let restaurantsVC = RestaurantsVC()
        let restaurantsTabBarItem = UITabBarItem(
            title: String(localized: "Restaurants"),
            image: UIImage(systemName: "fork.knife"),
            tag: 0
        )
        restaurantsVC.tabBarItem = restaurantsTabBarItem
        
        let scannerVC = ScannerVC()
        let scannerTabBarItem = UITabBarItem(
            title: String(localized: "Scanner"),
            image: UIImage(systemName: "qrcode"),
            tag: 1
        )
        scannerVC.tabBarItem = scannerTabBarItem
        
        let profileVC = ProfileVC()
        let profileTabBarItem = UITabBarItem(
            title: String(localized: "Profile"),
            image: UIImage(systemName: "person"),
            tag: 2
        )
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [restaurantsVC, scannerVC, profileVC]
    }
}
