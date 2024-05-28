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
    private let areOrdersEnable: Bool
    
    private enum MenuTab: Int, CaseIterable {
        case menu
        case feedback
        
        var name: String {
            switch self {
            case .menu: return String(localized: "Menu")
            case .feedback: return String(localized: "Feedback")
            }
        }
    }
    private var selectedTab: MenuTab?
    
    // MARK: Lifecycle
    
    init(model: MenuModelProtocol, areOrdersEnable: Bool) {
        self.model = model
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
        menuView.restaurantHeaderView.tabBarCollectionView.dataSource = self
        menuView.restaurantHeaderView.tabBarCollectionView.delegate = self
        if let firstTab = MenuTab.allCases.first {
            menuView.restaurantHeaderView.tabBarCollectionView.selectItem(
                at: IndexPath(item: 0, section: 0),
                animated: true,
                scrollPosition: .left
            )
            selectedTab = firstTab
        }
        menuView.tableView.dataSource = self
        menuView.tableView.delegate = self
        updateMenu()
        Task {
            menuView.restaurantHeaderView.logoImageView.image = await model.logoImage
        }
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        menuView.restaurantHeaderView.set(restaurant: model.restaurant)
    }
    
    // MARK: Update menu
    
    private func updateMenu() {
        Task {
            do {
                try await model.updateMenu(restaurantID: model.restaurant.id, limit: 100, offset: 0)
                let contentOffset = menuView.tableView.contentOffset
                menuView.tableView.reloadData()
                menuView.tableView.layoutIfNeeded()
                menuView.tableView.setContentOffset(contentOffset, animated: false)
//                if menuView.tableView.numberOfSections > 0 {
//                    menuView.tableView.reloadSections(
//                        IndexSet(integer: 0),
//                        with: .automatic
//                    )
//                    menuView.tableView.layoutIfNeeded()
//                    menuView.tableView.setContentOffset(contentOffset, animated: false)
//                } else {
//                    menuView.tableView.reloadData()
//                }
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                menuView.tableView.reloadData()
                showAlert(.gettingMenuServerError)
            }
        }
    }
    
    // MARK: Update feedback
    
    func updateFeedback(append: Bool = false) {
        Task {
            do {
                try await model.updateFeedback(append: false)
                let contentOffset = menuView.tableView.contentOffset
                menuView.tableView.reloadData()
                menuView.tableView.layoutIfNeeded()
                menuView.tableView.setContentOffset(contentOffset, animated: false)
//                if menuView.tableView.numberOfSections > 0 {
//                    menuView.tableView.reloadSections(
//                        IndexSet(IndexSet(integer: 0)),
//                        with: .automatic
//                    )
//                    menuView.tableView.layoutIfNeeded()
//                    menuView.tableView.setContentOffset(contentOffset, animated: false)
//                } else {
//                    menuView.tableView.reloadData()
//                }
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                menuView.tableView.reloadData()
                showAlert(.getFeedbackServerError)
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension MenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let selectedTab else { return 0 }
        
        switch selectedTab {
        case .menu: return model.menu.count
        case .feedback: return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let selectedTab else { return nil }
        
        switch selectedTab {
        case .menu: return model.menu[section].category.capitalized
        case .feedback: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedTab else { return 0 }
        
        switch selectedTab {
        case .menu: return model.menu[section].beverages.count
        case .feedback:
            switch section {
            case 0: return 1
            case 1: return model.feedback.count
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectedTab else { return UITableViewCell () }
        
        switch selectedTab {
        case .menu:
            guard let cell = menuView.tableView.dequeueReusableCell(
                withIdentifier: MenuTableViewCell.identifier,
                for: indexPath
            ) as? MenuTableViewCell else { return UITableViewCell() }
            
            let beverage = model.menu[indexPath.section].beverages[indexPath.row]
            
            cell.configure(beverage: beverage, isOrderEnable: areOrdersEnable, delegate: self)

            return cell
        case .feedback:
            switch indexPath.section {
            case 0:
                let leaveFeedbackCell = LeaveFeedbackTableViewCell()
                leaveFeedbackCell.leaveFeedbackButton.addAction(UIAction { [weak self] _ in
                    guard let self else { return }
                    
                    self.navigationController?.pushViewController(
                        LeaveFeedbackVC(model: self.model), animated: true
                    )
                }, for: .touchUpInside)
                return leaveFeedbackCell
            case 1:
                guard let cell = menuView.tableView.dequeueReusableCell(
                    withIdentifier: FeedbackTableViewCell.identifier,
                    for: indexPath
                ) as? FeedbackTableViewCell else { return UITableViewCell() }
                
                let feedback = model.feedback[indexPath.row]
                cell.configure(feedback: feedback)
                
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
}

// MARK: - UITableViewDelegate

extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTab else { return }
        
        switch selectedTab {
        case .menu:
            let beverage = model.menu[indexPath.section].beverages[indexPath.row]
            let beverageVC = BeverageVC(beverage: beverage)
            beverageVC.sheetPresentationController?.prefersGrabberVisible = true
            beverageVC.sheetPresentationController?.detents = [.medium(), .large()]
            present(beverageVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        case .feedback:
            break
        }
    }
    
}

// MARK: - MenuTableViewCellDelegate

extension MenuVC: MenuTableViewCellDelegate {
    
    func didClickOnCellWith(beverageID: Int) {
        Task {
            do {
                let order = PlaceOrder(beverage: beverageID)
                try await model.makeOrder(order)
                showAlert(.orderMade)
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                showAlert(.makingOrderServerError)
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource

extension MenuVC: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        MenuTab.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MenuTabCollectionViewCell.identifier,
            for: indexPath
        ) as? MenuTabCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(name: MenuTab.allCases[indexPath.row].name)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension MenuVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedTab = MenuTab(rawValue: indexPath.row) else { return }
        
        self.selectedTab = selectedTab
        
        switch selectedTab {
        case .menu: updateMenu()
        case .feedback: updateFeedback()
        }
    }
    
}
