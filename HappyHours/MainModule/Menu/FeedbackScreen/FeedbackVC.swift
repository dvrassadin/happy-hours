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
    private let userService: UserServiceProtocol
    
    // MARK: Lifecycle

    init(feedback: Feedback, model: MenuModelProtocol, userService: UserServiceProtocol) {
        self.feedback = feedback
        self.model = model
        self.userService = userService
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
        updateAnswers()
        showAnswerInputView()
        feedbackView.answerInputView.sendButton.addAction(UIAction { [weak self] _ in
            self?.sendAnswer()
        }, for: .touchUpInside)
    }
    
    // MARK: Update answers
    
    private func updateAnswers(withScroll: Bool = false) {
        Task {
            do {
                try await model.updateFeedbackAnswers(feedbackID: feedback.id, append: false)
                feedbackView.tableView.reloadData()
                if withScroll {
                    let lastSection = feedbackView.tableView.numberOfSections - 1
                    let lastRow = feedbackView.tableView.numberOfRows(inSection: lastSection) - 1
                    let lastRowIndexPath = IndexPath(row: lastRow, section: lastSection)
                    feedbackView.tableView.scrollToRow(
                        at: lastRowIndexPath,
                        at: .top,
                        animated: true
                    )
                }
            } catch AuthError.invalidToken {
//                showAlert(.invalidToken) { _ in
//                    UIApplication.shared.sendAction(
//                        #selector(LogOutDelegate.logOut),
//                        to: nil,
//                        from: self,
//                        for: nil
//                    )
//                }
                logOutWithAlert()
            } catch {
                showAlert(.getFeedbackAnswersServerError)
            }
        }
    }
    
    // MARK: Check feedback owner
    
    private func showAnswerInputView() {
        Task {
            do {
                if try await userService.getUser().email == feedback.user {
                    feedbackView.setUpAnswerInputView()
                }
            } catch AuthError.invalidToken {
//                showAlert(.invalidToken) { _ in
//                    UIApplication.shared.sendAction(
//                        #selector(LogOutDelegate.logOut),
//                        to: nil,
//                        from: self,
//                        for: nil
//                    )
//                }
                logOutWithAlert()
            }
        }
    }
    
    // MARK: Send answer
    
    private func sendAnswer() {
        guard let text = feedbackView.answerInputView.textView.text, !text.isEmpty else { return }
        Task {
            do {
                try await model.sendFeedbackAnswer(feedbackID: feedback.id, text: text)
                updateAnswers(withScroll: true)
                feedbackView.answerInputView.textView.text.removeAll()
            } catch AuthError.invalidToken {
//                showAlert(.invalidToken) { _ in
//                    UIApplication.shared.sendAction(
//                        #selector(LogOutDelegate.logOut),
//                        to: nil,
//                        from: self,
//                        for: nil
//                    )
//                }
                logOutWithAlert()
            } catch {
                showAlert(.sendFeedbackAnswerServerError)
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
