//
//  MenuTabCollectionViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 27/5/24.
//

import UIKit

final class MenuTabCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "MenuTabCell"
    override var isSelected: Bool {
        didSet { selectionLine.isHidden = !isSelected }
    }
    
    // MARK: UI components
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let selectionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .main
        view.isHidden = true
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubViews()
        setUpConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(selectionLine)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            selectionLine.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1),
            selectionLine.widthAnchor.constraint(equalTo: nameLabel.widthAnchor),
            selectionLine.heightAnchor.constraint(equalToConstant: 2),
            selectionLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
    }
}
