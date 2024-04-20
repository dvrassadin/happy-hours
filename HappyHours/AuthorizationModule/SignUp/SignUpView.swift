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
    
    let nameTextField = AuthTextField(
        placeholder: String(localized: "Name"),
        textContentType: .name,
        keyboardType: .namePhonePad
    )
    
    let dateOfBirthTextField = AuthTextField(
        placeholder: String(localized: "Date of Birth"),
        textContentType: .dateTime
    )
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: .now)
        return datePicker
    }()
    
    let emailTextField = AuthTextField(
        placeholder: String(localized: "Email Address"),
        textContentType: .emailAddress,
        keyboardType: .emailAddress
    )
    
    let passwordTextField = AuthTextField(
        placeholder: String(localized: "Password"),
        textContentType: .newPassword
    )
    
    let confirmPasswordTextField = AuthTextField(
        placeholder: String(localized: "Confirm Password"),
        textContentType: .newPassword
    )
    
    let createAccountButton = CommonButton(title: "Create Account")

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
                    equalToSystemSpacingBelow: screenNameLabel.bottomAnchor,
                    multiplier: AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                nameTextField.widthAnchor.constraint(
                    equalTo: widthAnchor,
                    multiplier: CommonSizes.textFieldWidthMultiplier
                ),
                nameTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: CommonSizes.textFieldHeightMultiplier
                ),
                
                dateOfBirthTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                dateOfBirthTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: nameTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                dateOfBirthTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                dateOfBirthTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                emailTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: dateOfBirthTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                emailTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                passwordTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: emailTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                passwordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                passwordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                confirmPasswordTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: passwordTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
                ),
                confirmPasswordTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                confirmPasswordTextField.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                createAccountButton.topAnchor.constraint(
                    equalToSystemSpacingBelow: confirmPasswordTextField.bottomAnchor,
                    multiplier: AuthSizes.topBetweenTextFieldsMultiplier
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
    // TODO: Decide whether to use keyboardLayoutGuide or both
//    override func moveUpContentToElement() -> UIView? {
//        print(createAccountButton.frame)
//        return createAccountButton
//    }

}
