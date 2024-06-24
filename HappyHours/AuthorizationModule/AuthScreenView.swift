//
//  AuthScreenView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

// MARK: - AuthScreenView class

/// This is the base class for authentication screens which contains application name label and screen name label.
class AuthScreenView: UIView {
    
    // MARK: UI components

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Regular_Bold", size: 24)
        label.textAlignment = .center
        label.textColor = .mainText
        label.text = String(localized: "Happy Hours")
        return label
    }()
    
    let screenNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        label.textColor = .mainText
        return label
    }()
    
    // MARK: Lifecycle
    
    init(screenName: String) {
        super.init(frame: .zero)
        screenNameLabel.text = screenName
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let textField = subview as? UITextField {
            textField.delegate = self
        }
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstrains()
    }
    
    private func addSubviews() {
        addSubview(appNameLabel)
        addSubview(screenNameLabel)
    }
    
    private func setUpConstrains() {
        NSLayoutConstraint.activate(
            [
                appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                appNameLabel.topAnchor.constraint(
                    lessThanOrEqualToSystemSpacingBelow: safeAreaLayoutGuide.topAnchor,
                    multiplier: 1.8
                ),
                
                screenNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                screenNameLabel.topAnchor.constraint(
                    lessThanOrEqualToSystemSpacingBelow: appNameLabel.bottomAnchor,
                    multiplier: 13
                ),
                screenNameLabel.topAnchor.constraint(
                    greaterThanOrEqualTo: appNameLabel.bottomAnchor
                )
            ]
        )
    }
    
    // MARK: User interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension AuthScreenView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
