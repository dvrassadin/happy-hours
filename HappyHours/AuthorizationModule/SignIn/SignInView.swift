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
    
    weak var delegate: SignInViewDelegate?
    
    // MARK: UI components
    
    private let emailTextField = AuthTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    private let passwordTextField = AuthTextField(
        placeholder: String(localized: "Password"),
        textContentType: .password
    )
    
    private let logInButton = AuthButton(title: "Log In")
    
    private let resetButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Reset Password"),
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12)])
        )
        button.configuration?.baseForegroundColor = .black
        return button
    }()
    
//    private let signUpTextView = SignUpTextView()
    private let signUpStackView = SignUpStackView()
    
    // MARK: Lifecycle
    
    init() {
        super.init(screenName: String(localized: "Sign In to Continue"))
        addSubviews()
//        signUpTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstrains()
    }
    
    // MARK: Set up UI
    
    private func addSubviews() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(logInButton)
        addSubview(resetButton)
        addSubview(signUpStackView)
    }
    
    private func setupConstrains() {
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
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                passwordTextField.topAnchor.constraint(
                    equalTo: emailTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                logInButton.topAnchor.constraint(
                    equalTo: passwordTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                logInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                logInButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
                logInButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
                
                resetButton.topAnchor.constraint(
                    equalTo: logInButton.bottomAnchor,
                    constant: frame.height * AuthSizes.topReserButtonMultiplier
                ),
                resetButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor),
                
                signUpStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                signUpStackView.bottomAnchor.constraint(
                    equalTo: bottomAnchor,
                    constant: frame.height * AuthSizes.bottomSignUpTextViewMultiplier
                )
            ]
        )
    }
    
    // MARK: User interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

//// MARK: - UITextViewDelegate
//
//extension SignInView: UITextViewDelegate {
//    func textView(
//        _ textView: UITextView,
//        shouldInteractWith URL: URL,
//        in characterRange: NSRange
//    ) -> Bool {
//        guard URL.absoluteString == SignUpTextView.link else { return true }
//        print("Sign up text tapped.")
//        return false
//    }
//}

//final class SignInView: UIView {
//
//    // MARK: UI components
//
//    private let appNameLabel = AppNameLabel()
//
//    private let screenNameLabel = AuthScreenNameLabel(
//        text: String(localized: "Sign In to Continue")
//    )
//
//    private let emailTextField = CustomTextField(
//        placeholder: String(localized: "Email Address"),
//        textContentType: .emailAddress,
//        keyboardType: .emailAddress
//    )
//
//    private let passwordTextField = CustomTextField(
//        placeholder: String(localized: "Password"),
//        textContentType: .password
//    )
//
//    // MARK: Lifecycle
//
//    init() {
//        super.init(frame: .zero)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupConstrains()
//    }
//
//    // MARK: Setup UI
//
//    private func setupUI() {
//        backgroundColor = .Custom.background
//        addSubviews()
//    }
//
//    private func addSubviews() {
//        addSubview(appNameLabel)
//        addSubview(screenNameLabel)
//        addSubview(emailTextField)
//        addSubview(passwordTextField)
//    }
//
//    private func setupConstrains() {
//        NSLayoutConstraint.activate(
//            [
//                appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                appNameLabel.topAnchor.constraint(
//                    equalTo: safeAreaLayoutGuide.topAnchor,
//                    constant: frame.height * 0.1157
//                ),
//
//                screenNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                screenNameLabel.topAnchor.constraint(
//                    equalTo: appNameLabel.bottomAnchor,
//                    constant: frame.height * 0.1342
//                ),
//
//                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                emailTextField.topAnchor.constraint(
//                    equalTo: screenNameLabel.bottomAnchor,
//                    constant: frame.height * 0.0431
//                ),
//                emailTextField.widthAnchor.constraint(
//                    equalTo: widthAnchor,
//                    multiplier: AuthSizes.textFieldWidthMultiplier
//                ),
//                emailTextField.heightAnchor.constraint(
//                    equalTo: safeAreaLayoutGuide.heightAnchor,
//                    multiplier: AuthSizes.textFieldHeightMultiplier
//                ),
//
//                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
//                passwordTextField.topAnchor.constraint(
//                    equalTo: emailTextField.bottomAnchor,
//                    constant: frame.height * 0.0259
//                ),
//                passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
//                passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
//            ]
//        )
//    }
//}
