//
//  CommonButton.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

final class CommonButton: UIButton {

    // MARK: Lifecycle
    
    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setUpAppearance()
        configuration?.attributedTitle = AttributedString(
            title,
            attributes: .init([.font: UIFont.systemFont(ofSize: 20)])
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up appearance

    private func setUpAppearance() {
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
