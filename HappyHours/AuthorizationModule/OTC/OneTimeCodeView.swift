//
//  OneTimeCodeView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/4/24.
//

import UIKit

// MARK: - OneTimeCodeView class

final class OneTimeCodeView: AuthScreenView {
    
    // MARK: Properties
    
    private let numberOfDigits: UInt
    private var digitsLabels = [UILabel]()
    var oneTimeCodeFilled: ((String) -> Void)?
    
    // MARK: UI components
    
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.textColor = .clear
        return textField
    }()
    
    private let cellsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    // MARK: Lifecycle
    
    init(numberOfDigits: UInt) {
        self.numberOfDigits = numberOfDigits
        super.init(screenName: String(localized: "Enter Code"))
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: Find out how to set corner radius after layout
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let cornerRadius = min(stackView.frame.height, stackView.frame.width) / 8
//        digitsLabels.forEach { $0.layer.cornerRadius = cornerRadius }
//    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubviews()
        setUpConstraints()
        configureLabels()
        codeTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func addSubviews() {
        addSubview(codeTextField)
        codeTextField.addSubview(cellsStackView)
    }
    
    private func configureLabels() {
        for _ in 0..<numberOfDigits {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.textColor = .Custom.primary
            label.font = .boldSystemFont(ofSize: 40)
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1
            label.clipsToBounds = true
            label.layer.cornerRadius = 5
            label.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(
                target: codeTextField,
                action: #selector(becomeFirstResponder)
            )
            label.addGestureRecognizer(gestureRecognizer)
            digitsLabels.append(label)
            cellsStackView.addArrangedSubview(label)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
//                codeTextField.topAnchor.constraint(
//                    equalTo: screenNameLabel.bottomAnchor,
//                    constant: frame.height * AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
//                ),
                codeTextField.topAnchor.constraint(
                    equalToSystemSpacingBelow: screenNameLabel.bottomAnchor,
                    multiplier: AuthSizes.topBetweenScreenNameAndFirstTextFiledMultiplier
                ),
                codeTextField.widthAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.widthAnchor,
                    multiplier: AuthSizes.oneTimeCodeWidthMultipier
                ),
                codeTextField.heightAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.heightAnchor,
                    multiplier: AuthSizes.textFieldHeightMultiplier * 2
                ),
                codeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                cellsStackView.topAnchor.constraint(equalTo: codeTextField.topAnchor),
                cellsStackView.leadingAnchor.constraint(equalTo: codeTextField.leadingAnchor),
                cellsStackView.trailingAnchor.constraint(equalTo: codeTextField.trailingAnchor),
                cellsStackView.bottomAnchor.constraint(equalTo: codeTextField.bottomAnchor)
            ]
        )
    }
    
    // MARK: User interaction
    
    @objc private func textDidChange() {
        guard let text = codeTextField.text, text.count <= numberOfDigits else { return }
        
        digitsLabels.enumerated().forEach { i, label in
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                label.text = String(text[index])
            } else {
                label.text?.removeAll()
            }
        }
        if text.count == numberOfDigits {
            oneTimeCodeFilled?(text)
            codeTextField.text?.removeAll()
            textDidChange()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension OneTimeCodeView {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let count = textField.text?.count else { return false }
        return count < numberOfDigits || string.isEmpty
    }
    
}
