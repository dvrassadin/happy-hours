//
//  ProfileView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: UI components
    
    private let defaultAvatar = UIImage(
        systemName: "person.circle.fill"
    )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView(image: defaultAvatar)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let emailLabel: UILabel = {
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
    
    private let subscriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = String(localized: "Subscription")
        return label
    }()
    
    let subscriptionButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.baseForegroundColor = .mainText
        button.configuration?.imagePlacement = .trailing
        button.configuration?.titleAlignment = .leading
        button.configuration?.titlePadding = 10
        button.configuration?.buttonSize = .large
        button.contentHorizontalAlignment = .fill
        button.isEnabled = false
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.image = nil
            default:
                button.configuration?.image = UIImage(systemName: "chevron.right")
            }
        }
        return button
    }()
    
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
        addSubview(subscriptionLabel)
        addSubview(subscriptionButton)
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
                    constant: -10
                ),
                stackView.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor),
                
                Constraints.spaceBeforeFirstElement(for: profileButton, under: userImageView),
                Constraints.textFieldAndButtonHeighConstraint(for: profileButton, on: self),
                Constraints.textFieldAndButtonWidthConstraint(for: profileButton, on: self),
                profileButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
                subscriptionLabel.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20),
                subscriptionLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
                subscriptionLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
                
                subscriptionButton.topAnchor.constraint(equalTo: subscriptionLabel.bottomAnchor, constant: 5),
                subscriptionButton.leadingAnchor.constraint(equalTo: subscriptionLabel.leadingAnchor),
                subscriptionButton.trailingAnchor.constraint(equalTo: subscriptionLabel.trailingAnchor),
                
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
    
    func set(user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
    
    func set(avatar: UIImage?) {
        if let avatar {
            userImageView.image = avatar
        } else {
            userImageView.image = defaultAvatar
        }
    }
    
    func set(subscription: Subscription?) {
        if let subscription {
            subscriptionButton.configuration?.title = subscription.plan.name
            subscriptionButton.configuration?.subtitle = String(
                localized: "\(subscription.plan.duration) membership\nValid through \(subscription.endDate.formatted())"
            )
        } else {
            subscriptionButton.configuration?.title = String(
                localized: "You do not have a subscription"
            )
            subscriptionButton.configuration?.subtitle = String(
                localized: "Select your subscription plan."
            )
        }
        subscriptionButton.isEnabled = true
    }
    
    func setSubscriptionError() {
        subscriptionButton.configuration?.title = String(
            localized: "Failed to load subscription information"
        )
        subscriptionButton.configuration?.subtitle = nil
        subscriptionButton.isEnabled = false
    }
    
}
