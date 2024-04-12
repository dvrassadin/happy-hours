//
//  SignUpTextView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 11/4/24.
//

import UIKit

final class SignUpTextView: UITextView {
    
    // MARK: Properties
    
    static let link = "tappableText"

    // MARK: Lifecycle
    init() {
        super.init(frame: .zero, textContainer: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        isEditable = false
        isScrollEnabled = false
        backgroundColor = .clear
        
        // Creating text
        let text = NSMutableAttributedString(
            string: String(localized: "New Member?"),
            attributes: [.font: UIFont.systemFont(ofSize: 12)]
        )
        text.append(NSAttributedString(string: " "))
        
        let tappableText = NSMutableAttributedString(string: String(localized: "Sign up Here"))
        tappableText.addAttribute(
            .foregroundColor,
            value: UIColor.Custom.primary,
            range: NSMakeRange(0, tappableText.length)
        )
        tappableText.addAttribute(
            .link,
            value: Self.link,
            range: NSMakeRange(0, tappableText.length)
        )
        text.append(tappableText)
        
        attributedText = text
        sizeToFit()
    }
}
