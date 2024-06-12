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
    
    // MARK: UI components
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.image = UIImage(systemName: self.isSecureTextEntry ? "eye.slash" : "eye")
        button.configuration?.baseForegroundColor = .systemGray
        button.configuration?.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 4)
        if #available(iOS 17.0, *) {
            button.isSymbolAnimationEnabled = true
        }
        return button
    }()
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
            eyeButton.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.isSecureTextEntry.toggle()
                eyeButton.configuration?.image = UIImage(systemName: self.isSecureTextEntry ? "eye.slash" : "eye")
            }, for: .touchUpInside)
            rightView = eyeButton
            rightViewMode = .always
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
