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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Set up appearance

    private func setUpAppearance() {
        configuration = .borderedProminent()
        configuration?.cornerStyle = .capsule
        configuration?.baseForegroundColor = .Custom.primary
        configuration?.baseBackgroundColor = .Custom.back
        layer.shadowColor = UIColor.Custom.secondary.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
    
}
