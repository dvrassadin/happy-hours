//
//  SignUpView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 13/4/24.
//

import UIKit

// MARK: - SignUpView class

final class SignUpView: AuthScreenView {
    
    // MARK: UI components
    
    private let nameTextField = AuthTextField(
        placeholder: String(localized: "Name"),
        textContentType: .name,
        keyboardType: .namePhonePad
    )
    
    private let dateOfBirthTextField = AuthTextField(
        placeholder: String(localized: "Date of Birth"),
        textContentType: .dateTime
    )
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: .now)
        return datePicker
    }()
    
    private let emailTextField = AuthTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    private let passwordTextField = AuthTextField(
        placeholder: String(localized: "Password"),
        textContentType: .newPassword
    )
    
    private let confirmPasswordTextField = AuthTextField(
        placeholder: String(localized: "Confirm Password"),
        textContentType: .newPassword
    )
    
    let createAccountButton = AuthButton(title: "Create Account")

    // MARK: Lifecycle

    init() {
        super.init(screenName: "Create an Account")
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
        addSubviews()
        dateOfBirthTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
    }
    
    private func addSubviews() {
        dateOfBirthTextField.inputView = datePicker
        addSubview(nameTextField)
        addSubview(dateOfBirthTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(confirmPasswordTextField)
        addSubview(createAccountButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                nameTextField.topAnchor.constraint(
                    equalTo: screenNameLabel.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                nameTextField.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: AuthSizes.textFieldWidthMultiplier
                ),
                nameTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: AuthSizes.textFieldHeightMultiplier
                ),
                
                dateOfBirthTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                dateOfBirthTextField.topAnchor.constraint(
                    equalTo: nameTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                dateOfBirthTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                dateOfBirthTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                emailTextField.topAnchor.constraint(
                    equalTo: dateOfBirthTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                passwordTextField.topAnchor.constraint(
                    equalTo: emailTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                confirmPasswordTextField.topAnchor.constraint(
                    equalTo: passwordTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                confirmPasswordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                confirmPasswordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                createAccountButton.topAnchor.constraint(
                    equalTo: confirmPasswordTextField.bottomAnchor,
                    constant: frame.height * AuthSizes.topBetweenTextFieldsMultiplier
                ),
                createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                createAccountButton.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                createAccountButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: createAccountButton.bottomAnchor, multiplier: 1.05)
            ]
        )
    }
    
    // MARK: User interaction
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        dateOfBirthTextField.text = datePicker.date.formatted(date: .long, time: .omitted)
    }
    
//    override func moveUpContentToElement() -> UIView? {
//        print(createAccountButton.frame)
//        return createAccountButton
//    }

}
