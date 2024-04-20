//
//  ProfileView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class ProfileView: UIView {
    
    // MARK: UI components
    
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
        backgroundColor = .Custom.background
        addSubviews()
        setUpConstraints()
        logOutButton.addTarget(
            nil,
            action: #selector(LogOutDelegate.logOut),
            for: .touchUpInside
        )
    }
    
    private func addSubviews() {
        addSubview(logOutButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
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
    
}
