//
//  FeedbackHeaderView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/5/24.
//

import UIKit

final class FeedbackHeaderView: UIView {
    
    // MARK: UI components
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .mainText
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .mainText
        return label
    }()
    
    private let feedbackLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .mainText
        label.numberOfLines = 0
        return label
    }()
    
    private let answersHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .mainText
        label.text = String(localized: "Answers:")
        return label
    }()

    // MARK: Lifecycle
    
    init(feedback: Feedback) {
        super.init(frame: .zero)
        userNameLabel.text = feedback.displayUser
        dateLabel.text = feedback.createdAt.formatted()
        feedbackLabel.text = feedback.text
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUpUI
    
    private func setUpUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(userNameLabel)
        addSubview(dateLabel)
        addSubview(feedbackLabel)
        addSubview(answersHeaderLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            feedbackLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            feedbackLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            feedbackLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            
            answersHeaderLabel.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: 20),
            answersHeaderLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            answersHeaderLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            answersHeaderLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
