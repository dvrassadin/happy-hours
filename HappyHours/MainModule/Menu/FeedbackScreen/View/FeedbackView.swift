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
    
    lazy var answerInputView = AnswerInputView()
    
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
        setUpHidingKeyboard()
    }
    
    private func addSubviews() {
        addSubview(tableView)
        tableView.tableHeaderView = feedbackHeader
    }
    
    private func setUpConstraints() {
        let tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        tableViewBottomAnchor.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableViewBottomAnchor,
            
            feedbackHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor),
        ])
    }
    
    func setUpAnswerInputView() {
        addSubview(answerInputView)
        
        NSLayoutConstraint.activate([
            answerInputView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            answerInputView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            answerInputView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            answerInputView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            answerInputView.sendButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -5),
            
            tableView.bottomAnchor.constraint(equalTo: answerInputView.topAnchor)
        ])
    }
    
    // MARK: User interaction
    
    private func setUpHidingKeyboard() {
        tableView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(endEditing))
        )
    }
    
}
