//
//  SignInView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

// MARK: - SignInView

final class SignInView: AuthScreenView {
    
    // MARK: Properties
    
    var isLoggingIn: Bool = false {
        didSet {
            if isLoggingIn {
                logInButton.configuration?.attributedTitle = logInButtonTitle
                logInButton.configuration?.showsActivityIndicator = true
                logInButton.isEnabled = false
            } else {
                logInButton.configuration?.attributedTitle = logInButtonTitle
                logInButton.configuration?.showsActivityIndicator = false
                logInButton.isEnabled = true
            }
        }
    }
    private var logInButtonTitle: AttributedString {
        AttributedString(
            String(localized: isLoggingIn ? "Logging In" : "Log In"),
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
    }
    
    // MARK: UI components
    
    let emailTextField = CommonTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let passwordTextField = CommonTextField(
        placeholder: String(localized: "Password"),
        textContentType: .password
    )
    
    let logInButton = CommonButton(title: String(localized: "Log In"))
    
    let resetButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Reset Password"),
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12),
                                            .foregroundColor: UIColor.mainText])
        )
        button.configuration?.baseForegroundColor = .black
        return button
    }()
    
    private let signUpStackView = SignUpStackView()
    
    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Sign In to Continue"))
        setUpUI()
        
        // TODO: Delete
        emailTextField.text = "happyadmin@mail.com"
        passwordTextField.text = "kaganat1"
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
                Constraints.spaceBeforeFirstElement(for: emailTextField, under: screenNameLabel),
                
                Constraints.textFieldAndButtonWidthConstraint(for: emailTextField, on: self),
                Constraints.textFieldAndButtonHeighConstraint(for: emailTextField, on: self),
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: passwordTextField,
                    under: emailTextField
                ),
                passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                Constraints.topBetweenTextFieldsAndButtons(
                    for: logInButton,
                    under: passwordTextField
                ),
                logInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                logInButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                logInButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                resetButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: logInButton.bottomAnchor,
                    multiplier: 1.2
                ),
                resetButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
                
                signUpStackView.topAnchor.constraint(greaterThanOrEqualTo: resetButton.bottomAnchor, constant: -5),
                signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

                keyboardLayoutGuide.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 10)
            ]
        )
    }
    
    func showLoggingIn() {
        logInButton.configuration?.showsActivityIndicator = true
    }
    
}
