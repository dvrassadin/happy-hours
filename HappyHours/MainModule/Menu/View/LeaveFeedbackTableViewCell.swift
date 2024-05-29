//
//  LeaveFeedbackTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import UIKit

final class LeaveFeedbackTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "LeaveFeedbackCell"

    // MARK: UI components
    
    let leaveFeedbackButton = CommonButton(title: String(localized: "Leave Feedback"))
    
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
        contentView.addSubview(leaveFeedbackButton)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            leaveFeedbackButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leaveFeedbackButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            leaveFeedbackButton.widthAnchor.constraint(equalToConstant: 300),
            leaveFeedbackButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            leaveFeedbackButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

}
