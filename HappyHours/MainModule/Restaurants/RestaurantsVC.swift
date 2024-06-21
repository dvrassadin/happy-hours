//
//  RestaurantsVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

// MARK: - RestaurantsVC class

final class RestaurantsVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private let model: RestaurantsModelProtocol
    private let subscriptionService: SubscriptionServiceProtocol
    private let userService: UserServiceProtocol
    private lazy var restaurantsView = RestaurantsView()

    // MARK: Lifecycle
    
    init(
        model: RestaurantsModelProtocol,
        subscriptionService: SubscriptionServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.model = model
        self.subscriptionService = subscriptionService
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = restaurantsView
        restaurantsView.tableView.dataSource = self
        restaurantsView.tableView.delegate = self
        restaurantsView.tableView.refreshControl?.addTarget(
            self,
            action: #selector(updateRestaurants),
            for: .valueChanged
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "Establishments")
        restaurantsView.activityIndicator.startAnimating()
        updateRestaurants()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubscriptionStatus()
    }
    
    // MARK: Update restaurants
    
    @objc private func updateRestaurants() {
        Task {
            defer {
                restaurantsView.activityIndicator.stopAnimating()
                restaurantsView.tableView.refreshControl?.endRefreshing()
            }
            do {
                try await model.getRestaurants(limit: 100, offset: 0)
                restaurantsView.tableView.reloadData()
            } catch AuthError.invalidToken {
//                showAlert(.invalidToken) { _ in
//                    UIApplication.shared.sendAction(
//                        #selector(LogOutDelegate.logOut),
//                        to: nil,
//                        from: self,
//                        for: nil
//                    )
//                }
                logOutWithAlert()
            } catch {
                showAlert(.getRestaurantsServerError)
            }
        }
    }
    
    // MARK: Update subscription status
    
    private func updateSubscriptionStatus() {
        restaurantsView.subscriptionStatus = .updating
        Task {
            do {
                let isActive = try await subscriptionService.isSubscriptionActive
                restaurantsView.subscriptionStatus = isActive ? .active : .noActive
            } catch AuthError.invalidToken {
//                showAlert(.invalidToken) { _ in
//                    UIApplication.shared.sendAction(
//                        #selector(LogOutDelegate.logOut),
//                        to: nil,
//                        from: self,
//                        for: nil
//                    )
//                }
                logOutWithAlert()
            } catch {
                restaurantsView.subscriptionStatus = .error
            }
        }
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    let networkService = NetworkService(
        authService: AuthService(keyChainService: KeyChainService())
    )
    let userService: UserServiceProtocol = UserService(networkService: networkService)
    
    return RestaurantsVC(
        model: RestaurantsModel(
            networkService: networkService
        ),
        subscriptionService: SubscriptionService(networkService: networkService),
        userService: userService
    )
    
}

// MARK: - UITableViewDataSource

extension RestaurantsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RestaurantsTableViewCell.identifier,
            for: indexPath
        ) as? RestaurantsTableViewCell else { return UITableViewCell() }
        
        let restaurant = model.restaurants[indexPath.row]
        
        cell.configure(restaurant: restaurant)
        Task {
            if let stringLogo = restaurant.logo {
                cell.configure(logo: await model.getLogo(stringURL: stringLogo))
            }
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension RestaurantsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Task(priority: .high) {
            let logoImage: UIImage?
            if let stringLogo = model.restaurants[indexPath.row].logo {
                logoImage = await model.getLogo(stringURL: stringLogo)
            } else {
                logoImage = nil
            }
            let menuModel = MenuModel(
                restaurant: model.restaurants[indexPath.row],
                logoImage: logoImage,
                networkService: model.networkService
            )
            let menuVC = MenuVC(
                model: menuModel,
                userService: userService,
                areOrdersEnable: false
            )
            navigationController?.pushViewController(menuVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
