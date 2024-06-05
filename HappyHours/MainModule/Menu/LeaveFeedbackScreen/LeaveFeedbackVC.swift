//
//  LeaveFeedbackVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import UIKit

final class LeaveFeedbackVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var leaveFeedbackView = LeaveFeedbackView()
    private let model: MenuModelProtocol
    
    // MARK: Lifecycle
    
    init(model: MenuModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = leaveFeedbackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaveFeedbackView.textView.delegate = self
        setUpNavigationBar()
        setUpNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        leaveFeedbackView.textView.becomeFirstResponder()
    }
    
    // MARK: Set up navigation bar
    
    private func setUpNavigationBar() {
        title = String(localized: "Leave Feedback")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: String(localized: "Send"),
            style: .done,
            target: self,
            action: #selector(sendFeedback)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: Send feedback

    @objc private func sendFeedback() {
        guard let text = leaveFeedbackView.textView.text else { return }
        
        leaveFeedbackView.activityIndicator.startAnimating()
        Task {
            defer {
                leaveFeedbackView.activityIndicator.stopAnimating()
            }
            do {
                try await model.sendFeedback(text)
                navigationController?.popViewController(animated: true)
//                if let menuVC = navigationController?.topViewController as? MenuVC {
//                    menuVC.updateFeedback()
//                }
            } catch AuthError.invalidToken {
                showAlert(.invalidToken) { _ in
                    UIApplication.shared.sendAction(
                        #selector(LogOutDelegate.logOut),
                        to: nil,
                        from: self,
                        for: nil
                    )
                }
            } catch {
                showAlert(.sendFeedbackServerError)
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension LeaveFeedbackVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, !text.isEmpty, text.count > 5 else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
