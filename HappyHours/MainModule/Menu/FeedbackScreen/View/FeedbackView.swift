//
//  FeedbackView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import UIKit
import MessageUI

final class FeedbackView: UIView {

    // MARK: UI components
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            FeedbackAnswerTableViewCell.self,
            forCellReuseIdentifier: FeedbackAnswerTableViewCell.identifier
        )
        tableView.backgroundColor = .background
        return tableView
    }()
    
    private let feedbackHeader: FeedbackHeaderView
    
//    private let messageTextView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//    
//    private let sendButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    // MARK: Lifecycle
    
    init(feedback: Feedback) {
        feedbackHeader = FeedbackHeaderView(feedback: feedback)
        super.init(frame: .zero)
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
        addSubview(tableView)
        tableView.tableHeaderView = feedbackHeader
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            feedbackHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
    }
    
}
