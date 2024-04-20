//
//  SignInView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

// MARK: - SignInView

final class SignInView: AuthScreenView {
    
    // MARK: UI components
    
    let emailTextField = AuthTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let passwordTextField = AuthTextField(
        placeholder: String(localized: "Password"),
        textContentType: .password
    )
    
    let logInButton = CommonButton(title: "Log In")
    
    let resetButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Reset Password"),
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12)])
        )
        button.configuration?.baseForegroundColor = .black
        return button
    }()
    
    private let signUpStackView = SignUpStackView()
    
    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Sign In to Continue"))
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setUpConstrains()
//    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(logInButton)
        addSubview(resetButton)
        addSubview(signUpStackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                emailTextField.topAnchor.constraint(
//                    equalTo: screenNameLabel.bottomAnchor,
//                    constant: frame.height * AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
//                ),
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
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                passwordTextField.topAnchor.constraint(
//                    equalTo: emailTextField.bottomAnchor,
//                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
//                ),
                passwordTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: emailTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
//                logInButton.topAnchor.constraint(
//                    equalTo: passwordTextField.bottomAnchor,
//                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
//                ),
                logInButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: passwordTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                logInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                logInButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                logInButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
//                resetButton.topAnchor.constraint(
//                    equalTo: logInButton.bottomAnchor,
//                    constant: frame.height * AuthSizes.topReserButtonMultiplier
//                ),
                resetButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: logInButton.bottomAnchor,
                    multiplier: AuthSizes.topReserButtonMultiplier
                ),
                resetButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
                
                signUpStackView.topAnchor.constraint(greaterThanOrEqualTo: resetButton.bottomAnchor, constant: -5),
                signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

                keyboardLayoutGuide.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 10)
            ]
        )
    }
    
}
