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
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func addSubviews() {
        contentView.addSubview(logoImageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(clockImageView)
//        contentView.addSubview(hoursLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
//            nameLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor),
//            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 2),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
//            
//            clockImageView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 2),
//            clockImageView.heightAnchor.constraint(equalToConstant: 20),
//            clockImageView.widthAnchor.constraint(equalTo: clockImageView.heightAnchor),
//            clockImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
//            
//            hoursLabel.centerYAnchor.constraint(equalTo: clockImageView.centerYAnchor),
//            hoursLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor),
//            hoursLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    // MARK: Configure data
    
    func configure(restaurant: Restaurant) {
        logoImageView.image = restaurant.image
        nameLabel.text = restaurant.name
        hoursLabel.text = restaurant.hours
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
        nameLabel.text = nil
        hoursLabel.text = nil
    }
}
