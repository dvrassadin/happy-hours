//
//  AnswerInputView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 4/6/24.
//

import UIKit

final class AnswerInputView: UIView {
    
    // MARK: Properties
    
    private let textViewMaxHeight: CGFloat = 300
    
    private lazy var textViewHeightAnchor: NSLayoutConstraint = {
        let constraint = textView.heightAnchor.constraint(equalToConstant: textViewMaxHeight)
        return constraint
    }()
    
    private var isOversized = false {
        didSet {
            guard oldValue != isOversized else { return }
            textView.isScrollEnabled = isOversized
            textView.setNeedsUpdateConstraints()
            textViewHeightAnchor.constant = textView.frame.height
            textViewHeightAnchor.isActive = isOversized
        }
    }

    // MARK: UI components
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .TextField.text
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.TextField.editingBorder.cgColor
        textView.tintColor = .main
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.image = UIImage(systemName: "arrow.up.circle.fill")
        button.configuration?.baseForegroundColor = .main
        button.isEnabled = false
        return button
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(textView)
        addSubview(sendButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textView.topAnchor.constraint(lessThanOrEqualTo: sendButton.topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.bottomAnchor.constraint(equalTo: sendButton.bottomAnchor),
            
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

}

// MARK: - UITextViewDelegate

extension AnswerInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        isOversized = textView.contentSize.height > textViewMaxHeight
        
        if let text = textView.text, !text.isEmpty {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
}
