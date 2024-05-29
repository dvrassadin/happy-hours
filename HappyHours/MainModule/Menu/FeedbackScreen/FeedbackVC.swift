//
//  FeedbackVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import UIKit

// MARK: - FeedbackVC class

final class FeedbackVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private let feedback: Feedback
    private lazy var feedbackView = FeedbackView(feedback: feedback)
    private let model: MenuModelProtocol
    
    // MARK: Lifecycle

    init(feedback: Feedback, model: MenuModelProtocol) {
        self.feedback = feedback
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = feedbackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackView.tableView.dataSource = self
        feedbackView.tableView.delegate = self
        title = String(localized: "Feedback")
        Task {
            do {
                try await model.updateFeedbackAnswers(feedbackID: feedback.id, append: false)
                feedbackView.tableView.reloadData()
            } catch {
                showAlert(.getFeedbackAnswersServerError)
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension FeedbackVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = feedbackView.tableView.dequeueReusableCell(
            withIdentifier: FeedbackAnswerTableViewCell.identifier,
            for: indexPath
        ) as? FeedbackAnswerTableViewCell else { return UITableViewCell() }
        let answer = model.answers[indexPath.row]
        cell.configure(answer: answer)
        return cell
    }
    
}

extension FeedbackVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        nil
    }
    
}
