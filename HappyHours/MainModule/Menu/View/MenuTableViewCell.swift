//
//  MenuTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class MenuTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "MenuCell"
    weak var delegate: MenuTableViewCellDelegate?
    private var beverageID: Int?

    // MARK: UI components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .mainText
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainText
        return label
    }()
    
    private let orderButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseBackgroundColor = .Button.pressed
            case .disabled:
                button.configuration?.baseBackgroundColor = .Button.disabled
            default:
                button.configuration?.baseBackgroundColor = .Button.default
            }
        }
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Get for\nFree"),
            attributes: .init([.font: UIFont.boldSystemFont(ofSize: 12)])
        )
        return button
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
        setUpNavigation()
    }
    
    private func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(orderButton)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: orderButton.leadingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            orderButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            orderButton.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: Configure data
    
    func configure(beverage: Beverage, isOrderEnable: Bool, delegate: MenuTableViewCellDelegate) {
        nameLabel.text = beverage.name.capitalized
        priceLabel.text = beverage.price
        beverageID = beverage.id
        orderButton.isEnabled = isOrderEnable
        self.delegate = delegate
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        priceLabel.text = nil
        beverageID = nil
        delegate = nil
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        orderButton.addAction(UIAction { [weak self] _ in
            guard let self, let delegate, let beverageID else { return }
            delegate.didClickOnCellWith(beverageID: beverageID)
        }, for: .touchUpInside)
    }

}
