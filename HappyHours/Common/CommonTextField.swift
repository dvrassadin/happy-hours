//
//  CommonTextField.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

final class CommonTextField: UITextField {
    
    // MARK: Properties
    
    override var isEnabled: Bool {
        willSet {
            backgroundColor = newValue ? .white : .TextField.disabledBackground
        }
    }

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
            attributes: [.foregroundColor: UIColor.TextField.placeholder]
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
    
    // MARK: Set up appearance
    
    private func setUpAppearance() {
        borderStyle = .roundedRect
        returnKeyType = .done
        textColor = .mainText
        tintColor = .TextField.editingBorder
    }

}
