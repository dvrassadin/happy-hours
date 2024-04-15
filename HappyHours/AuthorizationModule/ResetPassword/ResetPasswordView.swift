//
//  ResetPasswordView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

final class ResetPasswordView: AuthScreenView {
    
    // MARK: UI components
    
    private let emailTextField = AuthTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let continueButton = AuthButton(title: "Continue")

    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Reset Password"))
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubViews()
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
                    equalTo: screenNameLabel.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                emailTextField.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: AuthSizes.textFieldWidthMultiplier
                ),
                emailTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: AuthSizes.textFieldHeightMultiplier
                ),
                
                continueButton.topAnchor.constraint(
                    equalTo: emailTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                continueButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                continueButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: continueButton.bottomAnchor, multiplier: 1.05)
            ]
        )
    }
}
