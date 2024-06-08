//
//  EditProfileView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class EditProfileView: UIView {
    
    // MARK: Properties
    
    var isUpdating: Bool = false {
        didSet {
            if isUpdating {
                updateButton.configuration?.attributedTitle = updateButtonTitle
                updateButton.configuration?.showsActivityIndicator = true
                updateButton.isEnabled = false
            } else {
                updateButton.configuration?.attributedTitle = updateButtonTitle
                updateButton.configuration?.showsActivityIndicator = false
                updateButton.isEnabled = true
            }
        }
    }
    private var updateButtonTitle: AttributedString {
        AttributedString(
            String(localized: isUpdating ? "Updating" : "Update"),
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
    }
    
    // MARK: UI components
    
    private let defaultAvatar: UIImage? = UIImage(
        systemName: "person.circle.fill"
    )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(
            image: defaultAvatar
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let editImageButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.image = UIImage(systemName: "pencil.circle.fill")
        button.configuration?.baseForegroundColor = .main
        return button
    }()
    
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
    
    let updateButton = CommonButton(title: String(localized: "Update"))

    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI

    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
        emailTextField.isEnabled = false
    }
    
    private func addSubviews() {
        addSubview(userImageView)
        addSubview(editImageButton)
        addSubview(nameTextField)
        addSubview(dateOfBirthLabel)
        addSubview(datePicker)
        addSubview(emailTextField)
        addSubview(updateButton)
    }
    
    private func setUpConstraints() {
        let editButtonCenterX = NSLayoutConstraint(
            item: editImageButton,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: userImageView,
            attribute: .trailing,
//            multiplier: 0.8536,
            multiplier: 0.95,
            constant: 0
        )
        let editButtonCenterY = NSLayoutConstraint(
            item: editImageButton,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: userImageView,
            attribute: .bottom,
//            multiplier: 0.8536,
            multiplier: 0.95,
            constant: 0
        )
        
        NSLayoutConstraint.activate(
            [
                userImageView.topAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.topAnchor,
                    constant: 20
                ),
                userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                userImageView.widthAnchor.constraint(equalToConstant: 80),
                userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
                
                editImageButton.widthAnchor.constraint(equalToConstant: 20),
                editImageButton.heightAnchor.constraint(equalTo: editImageButton.widthAnchor),
                editButtonCenterX,
                editButtonCenterY,
                
                nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                Constraints.spaceBeforeFirstElement(for: nameTextField, under: userImageView),
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
                
                Constraints.topBetweenTextFieldsAndButtons(
                    for: updateButton,
                    under: emailTextField
                ),
                updateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                updateButton.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
                updateButton.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualToSystemSpacingBelow: updateButton.bottomAnchor,
                    multiplier: 1.05
                )
            ]
        )
    }
    
    func set(user: User) {
//        if let avatar {
//            userImageView.image = avatar
//        }
        nameTextField.text = user.name
        if let dateOfBirth = user.dateOfBirth {
            datePicker.date = dateOfBirth
        }
        emailTextField.text = user.email
    }
    
    func set(avatar: UIImage?) {
        if let avatar {
            userImageView.image = avatar
        } else {
            userImageView.image = defaultAvatar
        }
    }
    
}
