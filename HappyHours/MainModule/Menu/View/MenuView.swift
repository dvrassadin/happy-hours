//
//  MenuView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class MenuView: UIView {

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            MenuTableViewCell.self,
            forCellReuseIdentifier: MenuTableViewCell.identifier
        )
        tableView.register(
            FeedbackTableViewCell.self,
            forCellReuseIdentifier: FeedbackTableViewCell.identifier
        )
        tableView.register(
            LeaveFeedbackTableViewCell.self,
            forCellReuseIdentifier: LeaveFeedbackTableViewCell.identifier
        )
        tableView.backgroundColor = .background
        return tableView
    }()
    
    let restaurantHeaderView = RestaurantHeaderView()
    
    // MARK: lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        tableView.tableHeaderView = restaurantHeaderView
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                restaurantHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
            ]
        )
    }

}
