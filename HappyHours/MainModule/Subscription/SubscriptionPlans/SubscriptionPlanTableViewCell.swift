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

    // MARK: UI components
    
    private let backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 15
        stackView.layer.borderWidth = 2
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10
        )
        return stackView
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let planNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.isHidden = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.numberOfLines = 0
        label.isHidden = true
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
        selectionStyle = .none
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(planNameLabel)
        nameStackView.addArrangedSubview(checkmarkImageView)
        backgroundStackView.addArrangedSubview(priceLabel)
        backgroundStackView.addArrangedSubview(divider)
        backgroundStackView.addArrangedSubview(descriptionLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                backgroundStackView.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: 10
                ),
                backgroundStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: 20
                ),
                backgroundStackView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -20
                ),
                backgroundStackView.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -10
                ),
                
                divider.heightAnchor.constraint(equalToConstant: 1)
            ]
        )
    }
    
    private func expand(isSelected: Bool) {
        setUpCheckmark(isSelected: isSelected)
        backgroundStackView.layer.borderColor = isSelected ? UIColor.main.cgColor : UIColor.clear.cgColor
        divider.isHidden = !isSelected
        descriptionLabel.isHidden = !isSelected
    }
    
    private func setUpCheckmark(isSelected: Bool) {
        if isSelected {
            let image = UIImage(systemName: "checkmark.circle.fill")
            checkmarkImageView.image = image
            checkmarkImageView.tintColor = .main
        } else {
            let image = UIImage(systemName: "circle")
            checkmarkImageView.image = image
            checkmarkImageView.tintColor = .systemGray
        }
    }
    
    // MARK: Configure data
    
    func configure(subscriptionPlan: SubscriptionPlan, isSelected: Bool) {
        planNameLabel.text = subscriptionPlan.name
        if subscriptionPlan.freeTrialDays > 0 {
            priceLabel.text = String(
                localized: "\(subscriptionPlan.price) KGS/\(subscriptionPlan.freeTrialDays) days"
            )
        } else {
            priceLabel.text = "\(subscriptionPlan.price) KGS/\(subscriptionPlan.duration)"
        }
        descriptionLabel.text = subscriptionPlan.description
        expand(isSelected: isSelected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        planNameLabel.text = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
    }
    
}
