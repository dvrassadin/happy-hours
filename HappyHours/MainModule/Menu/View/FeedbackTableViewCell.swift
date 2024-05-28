//
//  FeedbackTabelViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 27/5/24.
//

import UIKit

final class FeedbackTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "FeedbackCell"
    private(set) var id: Int?

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
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(feedbackLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            dateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            
            feedbackLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            feedbackLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            feedbackLabel.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            feedbackLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    // MARK: Configure data
    
    func configure(feedback: Feedback) {
        userNameLabel.text = feedback.displayUser
        dateLabel.text = feedback.createdAt.formatted()
        feedbackLabel.text = feedback.text
        id = feedback.id
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = nil
        dateLabel.text = nil
        feedbackLabel.text = nil
        id = nil
    }

}
