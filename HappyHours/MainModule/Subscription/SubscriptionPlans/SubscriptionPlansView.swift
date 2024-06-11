//
//  SubscriptionPlansView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/6/24.
//

import UIKit

final class SubscriptionPlansView: UIView {
    
    // MARK: Properties
    
    private let allowSubscribe: Bool
    
    var isOpeningPayment: Bool = false {
        didSet {
            if isOpeningPayment {
                subscribeButton.configuration?.attributedTitle = subscriptionButtonTitle
                subscribeButton.configuration?.showsActivityIndicator = true
                subscribeButton.isEnabled = false
            } else {
                subscribeButton.configuration?.attributedTitle = subscriptionButtonTitle
                subscribeButton.configuration?.showsActivityIndicator = false
                subscribeButton.isEnabled = true
            }
        }
    }
    
    private var subscriptionButtonTitle: AttributedString {
        AttributedString(
            String(localized: isOpeningPayment ? "Opening Payment" : "Subscribe"),
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
    }

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SubscriptionPlanTableViewCell.self,
            forCellReuseIdentifier: SubscriptionPlanTableViewCell.identifier
        )
        tableView.register(
            SubscriptionPlanBasicTableViewCell.self,
            forCellReuseIdentifier: SubscriptionPlanBasicTableViewCell.identifier
        )
        tableView.backgroundColor = .background
        return tableView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .mainText
        label.text = String(
            localized: "Enjoy free beverages.\nYou can get one beverage per hour and one beverage at a place within a day."
        )
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .background
        return view
    }()
    
    lazy var subscribeButton = CommonButton(title: "Subscribe")
    
    // MARK: Lifecycle
    
    init(allowSubscribe: Bool) {
        self.allowSubscribe = allowSubscribe
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
        if allowSubscribe {
            subscribeButton.isEnabled = tableView.indexPathForSelectedRow != nil
        }
    }
    
    private func addSubviews() {
        tableView.tableHeaderView = headerLabel
        addSubview(tableView)
        if allowSubscribe {
            addSubview(bottomView)
            bottomView.addSubview(subscribeButton)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerLabel.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
        
        if allowSubscribe {
            NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
                bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                subscribeButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
                subscribeButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                Constraints.textFieldAndButtonHeighConstraint(for: subscribeButton, on: self),
                Constraints.textFieldAndButtonWidthConstraint(for: subscribeButton, on: bottomView),
                subscribeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }

}
