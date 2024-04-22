//
//  ResetPasswordView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

final class ResetPasswordView: AuthScreenView {
    
    // MARK: UI components
    
    let emailTextField = CommonTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let continueButton = CommonButton(title: String(localized: "Continue"))

    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Reset Password"))
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
        addSubview(emailTextField)
        addSubview(continueButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                emailTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: screenNameLabel.bottomAnchor,
                    multiplier: AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                emailTextField.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: CommonSizes.textFieldWidthMultiplier
                ),
                emailTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: CommonSizes.textFieldHeightMultiplier
                ),
                
                continueButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: emailTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                continueButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                continueButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: continueButton.bottomAnchor, multiplier: 1.05)
            ]
        )
    }
    
}
