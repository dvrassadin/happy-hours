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
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    }
    
    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(hoursLabel)
    }

    private func setUpConstraints() {
        
    }
    
    // MARK: Configure data
    
    func configure(restaurant: Restaurant) {
        logoImageView.image = UIImage(systemName: "star.leadinghalf.filled")
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
