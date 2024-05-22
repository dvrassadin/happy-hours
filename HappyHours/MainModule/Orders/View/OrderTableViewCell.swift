//
//  OrderTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/5/24.
//

import UIKit

final class OrderTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "OrderCell"

    // MARK: UI components
    
    private let beverageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .mainText
        return label
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainText
        return label
    }()
    
    private let statusLabel: StatusLabel = {
        let label = StatusLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainText
        label.layer.cornerCurve = .circular
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainText
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusLabel.layer.cornerRadius = statusLabel.frame.size.height / 2
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(beverageNameLabel)
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(dateLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            beverageNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            beverageNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            statusLabel.centerYAnchor.constraint(equalTo: beverageNameLabel.centerYAnchor),
            statusLabel.leadingAnchor.constraint(lessThanOrEqualTo: beverageNameLabel.trailingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            restaurantNameLabel.topAnchor.constraint(equalTo: beverageNameLabel.bottomAnchor, constant: 2),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: Configure data
    
    func configure(order: Order) {
        switch order.status {
        case .pending:
            statusLabel.layer.backgroundColor = UIColor.systemGray.cgColor
            statusLabel.text = String(localized: "pending")
        case .inPreparation:
            statusLabel.layer.backgroundColor = UIColor.main.cgColor
            statusLabel.text = String(localized: "preparation")
        case .completed:
            statusLabel.layer.backgroundColor = UIColor.systemGreen.cgColor
            statusLabel.text = String(localized: "completed")
        case .cancelled:
            statusLabel.layer.backgroundColor = UIColor.systemRed.cgColor
            statusLabel.text = String(localized: "cancelled")
        }
        beverageNameLabel.text = order.beverageName
        restaurantNameLabel.text = order.establishmentName
        dateLabel.text = order.orderDate.formatted()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beverageNameLabel.text = nil
        restaurantNameLabel.text = nil
        statusLabel.text = nil
        dateLabel.text = nil
    }

}
