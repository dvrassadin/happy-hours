//
//  ProfileView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: UI components
    
    let subscriptionStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        button.setTitle(String(localized: "Edit"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let logOutButton = CommonButton(title: String(localized: "Log Out"))

    // MARK: Lifecycle
    
    init() {
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
        logOutButton.addTarget(
            nil,
            action: #selector(LogOutDelegate.logOut),
            for: .touchUpInside
        )
    }
    
    private func addSubviews() {
        addSubview(subscriptionStatusLabel)
        addSubview(userImageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(editButton)
        addSubview(logOutButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                subscriptionStatusLabel.topAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.topAnchor,
                    constant: 10
                ),
                subscriptionStatusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                userImageView.topAnchor.constraint(
                    equalTo: subscriptionStatusLabel.bottomAnchor,
                    constant: 20
                ),
                userImageView.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: 10
                ),
                userImageView.widthAnchor.constraint(equalToConstant: 70),
                userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
                
                nameLabel.leadingAnchor.constraint(
                    equalTo: userImageView.trailingAnchor,
                    constant: 10
                ),
                nameLabel.bottomAnchor.constraint(equalTo: userImageView.centerYAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
                
                emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                emailLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
                
                editButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
                editButton.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -10
                ),
                
                logOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                logOutButton.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: CommonSizes.textFieldWidthMultiplier
                ),
                logOutButton.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: CommonSizes.textFieldHeightMultiplier
                ),
                
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualToSystemSpacingBelow: logOutButton.bottomAnchor,
                    multiplier: 1.05
                )
            ]
        )
    }
    
    func setUpUser() {
        subscriptionStatusLabel.text = "Active"
        userImageView.image = UIImage(systemName: "person.circle")
        nameLabel.text = "User"
        emailLabel.text = "email@example.com"
    }
    
}
