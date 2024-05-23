//
//  CommonButton.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

final class CommonButton: UIButton {

    // MARK: Lifecycle
    
    init(title: String, isTinted: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpAppearance(isTinted: isTinted)
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
        configuration?.imagePadding = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up appearance

    private func setUpAppearance(isTinted: Bool) {
        if isTinted {
            configuration = .borderedTinted()
            configuration?.baseForegroundColor = .Button.default
            configurationUpdateHandler = { button in
                switch button.state {
                case .highlighted:
                    button.configuration?.baseBackgroundColor = .Button.tintedPressed
                case .disabled:
                    button.configuration?.baseBackgroundColor = .Button.disabled
                default:
                    button.configuration?.baseBackgroundColor = .Button.tintedDefault
                }
            }
        } else {
            configuration = .borderedProminent()
            configurationUpdateHandler = { button in
                switch button.state {
                case .highlighted:
                    button.configuration?.baseBackgroundColor = .Button.pressed
                case .disabled:
                    button.configuration?.baseBackgroundColor = .Button.disabled
                default:
                    button.configuration?.baseBackgroundColor = .Button.default
                }
            }
        }
    }
    
}
