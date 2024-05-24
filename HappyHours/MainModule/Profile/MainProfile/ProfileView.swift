//
//  ProfileView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: UI components
    
    let userImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(
                systemName: "person.circle.fill"
            )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let profileButton = CommonButton(title: String(localized: "Edit Profile"))
    
    let logOutButton = CommonButton(title: String(localized: "Log Out"), isTinted: true)

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
    }
    
    private func addSubviews() {
        addSubview(userImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
        addSubview(stackView)
        addSubview(profileButton)
        addSubview(logOutButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                userImageView.topAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
                userImageView.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: 10
                ),
                userImageView.widthAnchor.constraint(equalToConstant: 80),
                userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
                
                stackView.leadingAnchor.constraint(
                    equalTo: userImageView.trailingAnchor,
                    constant: 10
                ),
                stackView.topAnchor.constraint(equalTo: userImageView.topAnchor),
                stackView.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -2
                ),
                stackView.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor),
                
                Constraints.spaceBeforeFirstElement(for: profileButton, under: userImageView),
                Constraints.textFieldAndButtonHeighConstraint(for: profileButton, on: self),
                Constraints.textFieldAndButtonWidthConstraint(for: profileButton, on: self),
                profileButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                logOutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.textFieldAndButtonWidthConstraint(for: logOutButton, on: self),
                Constraints.textFieldAndButtonHeighConstraint(for: logOutButton, on: self),
                
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualToSystemSpacingBelow: logOutButton.bottomAnchor,
                    multiplier: 1.05
                )
            ]
        )
    }
    
}
