//
//  MenuVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

// MARK: - MenuVC class

final class MenuVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var menuView = MenuView()
    private let model: MenuModelProtocol
//    private let restaurant: Restaurant
//    private let logoImage: UIImage?
    private let areOrdersEnable: Bool
    
    // MARK: Lifecycle
    
    init(model: MenuModelProtocol, areOrdersEnable: Bool) {
//        self.restaurant = restaurant
        self.model = model
//        self.logoImage = logoImage
        self.areOrdersEnable = areOrdersEnable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        menuView.restaurantHeaderView.set(restaurant: model.restaurant)
        Task {
            do {
                try await model.updateMenu(restaurantID: model.restaurant.id, limit: 100, offset: 0)
                menuView.tableView.reloadData()
            } catch {
                showAlert(.gettingMenuServerError)
            }
        }
        Task {
            menuView.restaurantHeaderView.logoImageView.image = await model.logoImage
        }
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    MenuVC(
        model: MenuModel(
            restaurant: Restaurant(
                id: 1,
                name: "Very long long long long restaurant name",
                description: "Very elegant and classy restaurant with romantic atmosphere tasty plates small portions professional staff and high prices but I think it's suitable for the high quality service they offer it's good for special occasions like anniversary or proposals. Usually there's a classical singer with a band in the evening singing inside the restaurant",
                phoneNumber: "+996 551 664 466",
                logo: nil,
                address: "Abdumomunova St., 220 A, Bishkek 720000 Kyrgyzstan",
                happyhoursStart: "19:00",
                happyhoursEnd: "20:00",
                email: "frunze312.kg@mail.ru"
            ),
            logoImage: nil,
            networkService: NetworkService(authService: AuthService(keyChainService: KeyChainService()))
        ),
        areOrdersEnable: true
    )
    
}

// MARK: - UITableViewDataSource

extension MenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.menu.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        model.menu[section].category.capitalized
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.menu[section].beverages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = menuView.tableView.dequeueReusableCell(
            withIdentifier: MenuTableViewCell.identifier,
            for: indexPath
        ) as? MenuTableViewCell else { return UITableViewCell() }
        
        let beverage = model.menu[indexPath.section].beverages[indexPath.row]
        
        cell.configure(beverage: beverage, isOrderEnable: areOrdersEnable, delegate: self)

        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - MenuTableViewCellDelegate

extension MenuVC: MenuTableViewCellDelegate {
    
    func didClickOnCellWith(beverageID: Int) {
        Task {
            do {
                let order = Order(beverage: beverageID)
                try await model.makeOrder(order)
                showAlert(.orderMade)
            } catch {
                showAlert(.makingOrderServerError)
            }
        }
    }
    
}
