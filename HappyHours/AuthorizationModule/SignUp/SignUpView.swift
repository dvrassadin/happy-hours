//
//  SignUpView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 13/4/24.
//

import UIKit

// MARK: - SignUpView class

final class SignUpView: AuthScreenView {
    
    // MARK: Properties
    
    var isCreatingAccount: Bool = false {
        didSet {
            if isCreatingAccount {
                createAccountButton.configuration?.attributedTitle = createAccountButtonTitle
                createAccountButton.configuration?.showsActivityIndicator = true
                createAccountButton.isEnabled = false
            } else {
                createAccountButton.configuration?.attributedTitle = createAccountButtonTitle
                createAccountButton.configuration?.showsActivityIndicator = false
                createAccountButton.isEnabled = true
            }
        }
    }
    private var createAccountButtonTitle: AttributedString {
        AttributedString(
            String(localized: isCreatingAccount ? "Creating Account" : "Create Account"),
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
    }
    
    // MARK: UI components
    
    let nameTextField = CommonTextField(
        placeholder: String(localized: "Name"),
        textContentType: .name,
        keyboardType: .namePhonePad
    )
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Date of Birth")
        label.textColor = .TextField.placeholder
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.maximumDate = .now
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: .now)
        datePicker.tintColor = .main
        return datePicker
    }()
    
    let emailTextField = CommonTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let passwordTextField = CommonTextField(
        placeholder: String(localized: "Password"),
        textContentType: .newPassword
    )
    
    let confirmPasswordTextField = CommonTextField(
        placeholder: String(localized: "Confirm Password"),
        textContentType: .newPassword
    )
    
    let createAccountButton = CommonButton(title: String(localized: "Create Account"))

    // MARK: Lifecycle

    init() {
        super.init(screenName: "Create an Account")
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
        addSubview(nameTextField)
        addSubview(dateOfBirthLabel)
        addSubview(datePicker)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(createAccountButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.spaceBeforeFirstElement(for: nameTextField, under: screenNameLabel),
                Constraints.textFieldAndButtonWidthConstraint(for: nameTextField, on: self),
                Constraints.textFieldAndButtonHeighConstraint(for: nameTextField, on: self),
                
                dateOfBirthLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                dateOfBirthLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
                dateOfBirthLabel.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                dateOfBirthLabel.trailingAnchor.constraint(equalTo: datePicker.leadingAnchor),
                
                Constraints.topBetweenTextFieldsAndButtons(for: datePicker, under: nameTextField),
                datePicker.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                datePicker.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.topBetweenTextFieldsAndButtons(for: emailTextField, under: datePicker),
                emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: passwordTextField,
                    under: emailTextField
                ),
                passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.topBetweenTextFieldsAndButtons(
                    for: confirmPasswordTextField,
                    under: passwordTextField
                ),
                confirmPasswordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                confirmPasswordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                Constraints.topBetweenTextFieldsAndButtons(
                    for: createAccountButton,
                    under: confirmPasswordTextField
                ),
                createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                createAccountButton.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                createAccountButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: createAccountButton.bottomAnchor, multiplier: 1.05)
            ]
        )
    }
    
    // MARK: User interaction
    
    // TODO: Decide whether to use keyboardLayoutGuide or both
//    override func moveUpContentToElement() -> UIView? {
//        print(createAccountButton.frame)
//        return createAccountButton
//    }

}
