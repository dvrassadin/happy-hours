//
//  LeaveFeedbackView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import UIKit

final class LeaveFeedbackView: UIView {

    // MARK: UI components
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .main
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI

    private func setUpUI() {
        backgroundColor = .background
        addSubViews()
        setUpConstraints()
    }
    
    private func addSubViews() {
        addSubview(textView)
        addSubview(activityIndicator)
    }
    
    private func setUpConstraints() {
        let bottomAnchor = textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        NSLayoutConstraint.activate(
            [
                textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                textView.leadingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.leadingAnchor,
                    constant: 10
                ),
                textView.trailingAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.trailingAnchor,
                    constant: -10
                ),
                textView.bottomAnchor.constraint(
                    lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor
                ),
                bottomAnchor,
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualTo: textView.bottomAnchor,
                    constant: 10
                ),
                
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    
    }
    
}
