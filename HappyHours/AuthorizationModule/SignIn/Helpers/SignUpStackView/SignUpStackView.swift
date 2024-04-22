//
//  SignUpStackView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 12/4/24.
//

import UIKit


/// Text with a button to go to the ``SignUpVC``
final class SignUpStackView: UIStackView {

    // MARK: UI components
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = String(localized: "New Member?")
        label.text?.append(" ")
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(configuration: .plain())
        button.configuration?.attributedTitle = AttributedString(
            String(localized: "Sign up Here"),
            attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12)])
        )
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseForegroundColor = .Button.pressed
            case .disabled:
                button.configuration?.baseForegroundColor = .Button.disabled
            default:
                button.configuration?.baseForegroundColor = .Button.default
            }
        }
        button.configuration?.contentInsets = .zero
        return button
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 0
        distribution = .fill
        axis = .horizontal
        alignment = .center
        addArrangedSubview(label)
        addArrangedSubview(button)
        
        button.addTarget(
            nil,
            action: #selector(SignUpStackViewDelegate.goToSignUp),
            for: .touchUpInside
        )
    }
    
}
