//
//  RestaurantsView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class RestaurantsView: UIView {
    
    // MARK: Properties
    
    enum SubscriptionStatus {
        case active, noActive, updating, error
        
        var message: String {
            switch self {
            case .active:
                return String(localized: "Your subscription is active. 🟢")
            case .noActive:
                return String(localized: "You do not have an active subscription. 🔴")
            case .updating:
                return String(localized: "Subscription status is updating... ")
            case .error:
                return String(localized: "Unable to get subscription status.")
            }
        }
    }
    var subscriptionStatus = SubscriptionStatus.updating {
        didSet {
            headerLabel.text = subscriptionStatus.message
        }
    }

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            RestaurantsTableViewCell.self,
            forCellReuseIdentifier: RestaurantsTableViewCell.identifier
        )
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .main
        return tableView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .main
        return activityIndicator
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
        headerLabel.text = SubscriptionStatus.updating.message
        tableView.tableHeaderView = headerLabel
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(tableView)
        addSubview(activityIndicator)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
