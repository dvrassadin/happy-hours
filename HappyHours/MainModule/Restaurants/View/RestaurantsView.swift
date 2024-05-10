//
//  RestaurantsView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class RestaurantsView: UIView {

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            RestaurantsTableViewCell.self,
            forCellReuseIdentifier: RestaurantsTableViewCell.identifier
        )
        tableView.refreshControl = UIRefreshControl()
        return tableView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    // MARK: Lifecycle
    
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
        tableView.tableHeaderView = headerLabel
        headerLabel.text = String(localized: "Your subscription is active. 🟢")
        addSubviews()
        setUpConstraints()
//        layoutIfNeeded()
    }
    
    private func addSubviews() {
        addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
    }
    
}
