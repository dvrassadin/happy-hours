//
//  MainTabBarController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class MainTabBarController: UITabBarController, AlertPresenter {
    
    private let networkService: NetworkServiceProtocol
    private let subscriptionService: SubscriptionServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        self.subscriptionService = SubscriptionService(networkService: networkService)
        self.userService = UserService(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        view.backgroundColor = .background
        tabBar.tintColor = .main
        title = String(localized: "Happy Hours")
        delegate = self
        setUpTabs()
    }
    
    private func setUpTabs() {
        let restaurantsModel: RestaurantsModelProtocol = RestaurantsModel(
            networkService: networkService
        )
        let restaurantsVC = RestaurantsVC(
            model: restaurantsModel,
            subscriptionService: subscriptionService,
            userService: userService
        )
        let restaurantsTabBarItem = UITabBarItem(
            title: String(localized: "Restaurants"),
            image: UIImage(systemName: "cup.and.saucer"),
            selectedImage: UIImage(systemName: "cup.and.saucer.fill")
        )
        restaurantsVC.tabBarItem = restaurantsTabBarItem
        
        let searchModel = SearchModel(networkService: networkService)
        let searchVC = SearchVC(model: searchModel, userService: userService)
        let searchTabBarItem = UITabBarItem(
            title: String(localized: "Search"),
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        searchVC.tabBarItem = searchTabBarItem
        
        let scannerVC = ScannerVC(networkService: networkService, userService: userService)
        let scannerTabBarItem = UITabBarItem(
            title: String(localized: "Scanner"),
            image: UIImage(systemName: "qrcode"),
            selectedImage: UIImage(systemName: "qrcode.viewfinder")
        )
        scannerVC.tabBarItem = scannerTabBarItem
        
        let ordersModel = OrdersModel(networkService: networkService)
        let orderVC = OrdersVC(model: ordersModel)
        let ordersTabBarItem = UITabBarItem(
            title: String(localized: "Orders"),
            image: UIImage(systemName: "list.bullet.rectangle"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        orderVC.tabBarItem = ordersTabBarItem
        
        let profileModel: ProfileModelProtocol = ProfileModel(
            networkService: networkService,
            userService: userService,
            subscriptionService: subscriptionService
        )
        let profileVC = ProfileVC(model: profileModel)
        let profileTabBarItem = UITabBarItem(
            title: String(localized: "Profile"),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        profileVC.tabBarItem = profileTabBarItem
        
        viewControllers = [restaurantsVC, searchVC, scannerVC, orderVC, profileVC]
    }
    
    // MARK: Open ScannerVC
    
    private func showSubscribeAlert() {
        let alertController = UIAlertController(
            title: String(localized: "No Subscription"),
            message: String(localized: "You must have a subscription to scan codes. See subscription plans."),
            preferredStyle: .alert
        )
        
        let notNowAction = UIAlertAction(title: String(localized: "Not Now"), style: .default)
        let chosePlaneAction = UIAlertAction(
            title: String(localized: "Chose a Plan"),
            style: .default
        ) { _ in
            let subscriptionModel = SubscriptionModel(
                networkService: self.networkService,
                subscriptionService: self.subscriptionService
            )
            let subscriptionPlansVC = SubscriptionPlansVC(
                model: subscriptionModel,
                allowSubscribe: true
            )
            self.navigationController?.pushViewController(subscriptionPlansVC, animated: true)
        }
        alertController.addAction(notNowAction)
        alertController.addAction(chosePlaneAction)
        present(alertController, animated: true)
    }
    
    private func openScanner() {
        Task {
            do {
                if try await subscriptionService.isSubscriptionActive {
                    selectedIndex = 2
                } else {
                    showSubscribeAlert()
                }
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.getSubscriptionServerError)
            }
        }
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    MainTabBarController(
        networkService: NetworkService(
            authService: AuthService(
                keyChainService: KeyChainService()
            )
        )
    )
    
}


extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if viewController is ScannerVC {
            openScanner()
            return false
        }
        return true
    }
    
}
