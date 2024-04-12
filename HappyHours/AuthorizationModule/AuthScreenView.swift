//
//  AuthScreenView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/4/24.
//

import UIKit

/// Base class for authentication screens which contains application name label and screen name label.
class AuthScreenView: UIView {
    
    // MARK: UI components

    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = String(localized: "Happy Hours")
        return label
    }()
    
    let screenNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    
    init(screenName: String) {
        super.init(frame: .zero)
        setupUI()
        screenNameLabel.text = screenName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstrains()
    }
    
    // MARK: Setup UI
    
    private func setupUI() {
        backgroundColor = .Custom.background
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(appNameLabel)
        addSubview(screenNameLabel)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            appNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            appNameLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: frame.height * AuthSizes.appNameLabelTopMultiplier
            ),
            
            screenNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            screenNameLabel.topAnchor.constraint(
                equalTo: appNameLabel.bottomAnchor,
                constant: frame.height * AuthSizes.screenNameLabelTopMultiplier
            )
        ])
    }
    
}
