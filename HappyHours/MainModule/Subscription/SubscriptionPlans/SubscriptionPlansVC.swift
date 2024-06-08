//
//  SubscriptionPlansVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/6/24.
//

import UIKit

final class SubscriptionPlansVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var subscriptionPlansView = SubscriptionPlansView()
    private let model: SubscriptionModelProtocol
    
    // MARK: Lifecycle
    
    init(model: SubscriptionModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = subscriptionPlansView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionPlansView.tableView.dataSource = self
        subscriptionPlansView.tableView.delegate = self
        updateSubscriptions()
    }
    
    // MARK: Update subscriptions
    
    private func updateSubscriptions() {
        Task {
            do {
                try await model.updateSubscription()
                subscriptionPlansView.tableView.reloadData()
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.getSubscriptionPlansServerError)
            }
        }
    }

}

// MARK: - UITableViewDataSource

extension SubscriptionPlansVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.subscriptionPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SubscriptionPlanTableViewCell.identifier,
            for: indexPath
        ) as? SubscriptionPlanTableViewCell else { return UITableViewCell() }
        
        cell.configure(subscriptionPlan: model.subscriptionPlans[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SubscriptionPlansVC: UITableViewDelegate {
    
}
