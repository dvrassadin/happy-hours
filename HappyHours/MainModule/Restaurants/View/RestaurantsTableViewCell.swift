//
//  RestaurantsTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import UIKit

final class RestaurantsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "RestaurantsCell"

    // MARK: UI components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let defaultLogo = UIImage(
        systemName: "storefront.fill"
    )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .mainText
        return label
    }()
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "clock.fill")?.withTintColor(
            .main,
            renderingMode: .alwaysOriginal
        )
        return imageView
    }()
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
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
        addSubviews()
        setUpConstraints()
        logoImageView.image = defaultLogo
    }
    
    private func addSubviews() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(clockImageView)
        contentView.addSubview(hoursLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 5),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            logoImageView.heightAnchor.constraint(equalToConstant: 70),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            clockImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            clockImageView.heightAnchor.constraint(equalToConstant: 15),
            clockImageView.widthAnchor.constraint(equalTo: clockImageView.heightAnchor),
            clockImageView.centerYAnchor.constraint(equalTo: hoursLabel.centerYAnchor),
            
            hoursLabel.topAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            hoursLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            hoursLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 5),
            hoursLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    // MARK: Configure data
    
    func configure(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        if let hhStart = restaurant.hhStart, let hhEnd = restaurant.hhEnd {
            hoursLabel.text = "\(hhStart) – \(hhEnd)"
        }
    }
    
    func configure(logo: UIImage?) {
        if let logo {
            logoImageView.image = logo
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = defaultLogo
        nameLabel.text = nil
        hoursLabel.text = nil
    }
    
}
