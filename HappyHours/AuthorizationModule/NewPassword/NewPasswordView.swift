//
//  NewPasswordView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

final class NewPasswordView: AuthScreenView {

    // MARK: UI components
    
    let passwordTextField = CommonTextField(
        placeholder: String(localized: "Password"),
        textContentType: .newPassword
    )
    
    let confirmPasswordTextField = CommonTextField(
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
                Constraints.spaceBeforeFirstElement(for: passwordTextField, under: screenNameLabel),
                Constraints.textFieldAndButtonWidthConstraint(for: passwordTextField, on: self),
                Constraints.textFieldAndButtonHeighConstraint(for: passwordTextField, on: self),
                
                confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: confirmPasswordTextField,
                    under: passwordTextField
                ),
                confirmPasswordTextField.widthAnchor.constraint(
                    equalTo: passwordTextField.widthAnchor
                ),
                confirmPasswordTextField.heightAnchor.constraint(
                    equalTo: passwordTextField.heightAnchor
                ),
                
                Constraints.topBetweenTextFieldsAndButtons(
                    for: createButton,
                    under: confirmPasswordTextField
                ),
                createButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                createButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
                createButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
            ]
        )
    }

}
