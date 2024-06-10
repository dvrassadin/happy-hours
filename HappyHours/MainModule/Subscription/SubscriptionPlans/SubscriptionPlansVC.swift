//
//  SubscriptionPlansVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/6/24.
//

import UIKit

final class SubscriptionPlansVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var subscriptionPlansView = SubscriptionPlansView(allowSubscribe: allowSubscribe)
    private let model: SubscriptionModelProtocol
    private let allowSubscribe: Bool
    private var selectedIndexPath: IndexPath?
    
    // MARK: Lifecycle
    
    init(model: SubscriptionModelProtocol, allowSubscribe: Bool) {
        self.model = model
        self.allowSubscribe = allowSubscribe
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
        title = String(localized: "Subscription Plans")
        subscriptionPlansView.tableView.dataSource = self
        subscriptionPlansView.tableView.delegate = self
        updateSubscriptions()
        if allowSubscribe {
            setUpNavigation()
        }
    }
    
    // MARK: Update subscriptions
    
    private func updateSubscriptions() {
        Task {
            do {
                try await model.updateSubscriptionPlans()
                subscriptionPlansView.tableView.reloadData()
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.getSubscriptionPlansServerError)
            }
        }
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        subscriptionPlansView.subscribeButton.addAction(UIAction { [weak self] _ in
            guard let self, let selectedIndexPath else { return }
            
            let subscriptionPlan = self.model.subscriptionPlans[selectedIndexPath.row]
            if subscriptionPlan.freeTrialDays > 0 {
                createFreeTrial(subscriptionPlanID: subscriptionPlan.id)
            } else {
                self.goToPaymentVC(subscriptionPlanID: subscriptionPlan.id)
            }
        }, for: .touchUpInside)
    }
    
    private func createFreeTrial(subscriptionPlanID: Int) {
        Task {
            do {
                try await model.createFreeTrial(subscriptionPlanID: subscriptionPlanID)
                navigationController?.popToRootViewController(animated: true)
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.createFreeTrialServerError)
            }
        }
    }

    private func goToPaymentVC(subscriptionPlanID: Int) {
        subscriptionPlansView.isOpeningPayment = true
        Task {
            defer {
                subscriptionPlansView.isOpeningPayment = false
            }
            do {
                let url = try await model.createPayment(subscriptionPlanID: subscriptionPlanID)
                let paymentVC = PaymentVC(model: model, paymentURL: url)
                navigationController?.pushViewController(paymentVC, animated: true)
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.createPaymentError)
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
        
        let plan = model.subscriptionPlans[indexPath.row]
        cell.configure(subscriptionPlan: plan, isSelected: selectedIndexPath == indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SubscriptionPlansVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subscriptionPlansView.subscribeButton.isEnabled = tableView.indexPathForSelectedRow != nil
        let oldSelectedIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        
        if let oldSelectedIndexPath {
            tableView.reloadRows(at: [oldSelectedIndexPath], with: .automatic)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            UITableView.automaticDimension
    }
    
}
