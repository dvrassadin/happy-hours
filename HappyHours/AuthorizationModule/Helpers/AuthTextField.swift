//
//  AuthTextField.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

final class AuthTextField: UITextField {

    // MARK: Lifecycle
    
    init(
        placeholder: String,
        textContentType: UITextContentType,
        keyboardType: UIKeyboardType? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.Custom.secondary]
        )
        self.textContentType = textContentType
        if let keyboardType {
            self.keyboardType = keyboardType
        }
        if textContentType == .password || textContentType == .newPassword {
            isSecureTextEntry = true
        }
        setUpAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: Set up appearance
    
    private func setUpAppearance() {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.Custom.secondary.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.Custom.background.cgColor
        returnKeyType = .done
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + layer.cornerRadius,
            y: bounds.origin.y,
            width: bounds.width - layer.cornerRadius * 2,
            height: bounds.height
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + layer.cornerRadius,
            y: bounds.origin.y,
            width: bounds.width - layer.cornerRadius * 2,
            height: bounds.height
        )
    }

}
