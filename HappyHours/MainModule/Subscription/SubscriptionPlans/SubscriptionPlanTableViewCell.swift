//
//  SubscriptionPlanTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/6/24.
//

import UIKit

final class SubscriptionPlanTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "SubscriptionPlansTableViewCell"
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                
//            } else {
//                
//            }
//        }
//    }

    // MARK: UI components
    
    private let backgroundRoundedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let planNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
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
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(backgroundRoundedView)
        backgroundRoundedView.addSubview(planNameLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundRoundedView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundRoundedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backgroundRoundedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backgroundRoundedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            planNameLabel.topAnchor.constraint(equalTo: backgroundRoundedView.topAnchor, constant: 10),
            planNameLabel.leadingAnchor.constraint(equalTo: backgroundRoundedView.leadingAnchor, constant: 10),
            planNameLabel.trailingAnchor.constraint(equalTo: backgroundRoundedView.trailingAnchor, constant: -10),
            
            planNameLabel.bottomAnchor.constraint(equalTo: backgroundRoundedView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: Configure data
    
    func configure(subscriptionPlan: SubscriptionPlan) {
        planNameLabel.text = subscriptionPlan.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        planNameLabel.text = nil
    }
}
