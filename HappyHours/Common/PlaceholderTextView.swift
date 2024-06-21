//
//  PlaceholderTextView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/6/24.
//

import UIKit

final class PlaceholderTextView: UITextView {

    // MARK: Properties
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            setNeedsLayout()
        }
    }
    
    override var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpUI()
        setUpPlaceholder()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
        setUpPlaceholder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        addSubview(placeholderLabel)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: textContainerInset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textContainerInset.left + textContainer.lineFragmentPadding),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(textContainerInset.right + textContainer.lineFragmentPadding)),
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -textContainerInset.bottom)
        ])
    }
    
    // MARK: Set up placeholder
    
    private func setUpPlaceholder() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
}
