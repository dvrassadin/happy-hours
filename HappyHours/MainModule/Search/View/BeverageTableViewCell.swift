//
//  BeverageTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 26/4/24.
//

import UIKit

final class BeverageTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "BeverageCell"
    
    // MARK: Set up UI
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .mainText
        return label
    }()
    
    private let establishmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(establishmentLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            establishmentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            establishmentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            establishmentLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            establishmentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: Configure data
    
    func configure(beverage: Beverage) {
        nameLabel.text = beverage.name
        establishmentLabel.text = beverage.establishment
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        establishmentLabel.text = nil
    }

}
