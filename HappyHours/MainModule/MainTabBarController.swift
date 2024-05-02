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
        view.backgroundColor = .background
        tabBar.tintColor = .main
        title = String(localized: "Happy Hours")
        setUpTabs()
    }
    
    private func setUpTabs() {
        let restaurantsModel: MainModelProtocol = MainModel()
        let restaurantsVC = RestaurantsVC(model: restaurantsModel)
        let restaurantsTabBarItem = UITabBarItem(
            title: String(localized: "Restaurants"),
            image: UIImage(systemName: "fork.knife"),
            selectedImage: UIImage(systemName: "fork.knife")
        )
        restaurantsVC.tabBarItem = restaurantsTabBarItem
        
        let searchVC = SearchVC()
        let searchTabBarItem = UITabBarItem(
            title: String(localized: "Search"),
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        searchVC.tabBarItem = searchTabBarItem
        
        let scannerVC = ScannerVC()
        let scannerTabBarItem = UITabBarItem(
            title: String(localized: "Scanner"),
            image: UIImage(systemName: "qrcode"),
            selectedImage: UIImage(systemName: "qrcode.viewfinder")
        )
        scannerVC.tabBarItem = scannerTabBarItem
        
        let profileModel: ProfileModelProtocol = ProfileModel()
        let profileVC = ProfileVC(model: profileModel)
        let profileTabBarItem = UITabBarItem(
            title: String(localized: "Profile"),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [restaurantsVC, searchVC, scannerVC, profileVC]
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    MainTabBarController()
}
