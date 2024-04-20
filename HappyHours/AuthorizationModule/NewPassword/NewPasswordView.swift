//
//  NewPasswordView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class NewPasswordView: AuthScreenView {

    // MARK: UI components
    
    let passwordTextField = AuthTextField(
        placeholder: String(localized: "Password"),
        textContentType: .newPassword
    )
    
    let confirmPasswordTextField = AuthTextField(
        placeholder: String(localized: "Confirm Password"),
        textContentType: .newPassword
    )
    
    let createButton = CommonButton(title: String(localized: "Create"))
    
    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Create New Password"))
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
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(createButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                passwordTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: screenNameLabel.bottomAnchor,
                    multiplier: AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                passwordTextField.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: CommonSizes.textFieldWidthMultiplier
                ),
                passwordTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: CommonSizes.textFieldHeightMultiplier
                ),
                
                confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                confirmPasswordTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: passwordTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                confirmPasswordTextField.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
                confirmPasswordTextField.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor),
                
                createButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: confirmPasswordTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                createButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                createButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
                createButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
            ]
        )
    }

}
