//
//  OrdersVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/5/24.
//

import UIKit

final class OrdersVC: UIViewController, AlertPresenter {

    // MARK: Properties
    
    private lazy var ordersView = OrdersView()
    private let model: OrdersModelProtocol
    private var isLoadingOrders = false
    
    // MARK: Lifecycle
    
    init(model: OrdersModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        ordersView.tableView.refreshControl?.addAction(UIAction { [weak self] _ in
            self?.updateOrders()
        }, for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ordersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersView.tableView.dataSource = self
        updateOrders()
    }
    
    // MARK: Update orders
    
    private func updateOrders(append: Bool = false) {
        isLoadingOrders = true
        
        if append {
            ordersView.tableView.tableFooterView = ordersView.footerActivityIndicator
            ordersView.footerActivityIndicator.startAnimating()
        } else {
            ordersView.activityIndicator.startAnimating()
        }
        
        Task {
            defer {
                ordersView.activityIndicator.stopAnimating()
                ordersView.footerActivityIndicator.stopAnimating()
                ordersView.tableView.tableFooterView = nil
                ordersView.tableView.refreshControl?.endRefreshing()
                isLoadingOrders = false
            }
            do {
                try await model.updateOrders(append: append)
                ordersView.tableView.reloadData()
            } catch {
                showAlert(.beveragesServerError)
            }
        }
    }
}


// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    OrdersVC(
        model: OrdersModel(
            networkService: NetworkService(
                authService: AuthService(
                    keyChainService: KeyChainService()
                )
            )
        )
    )
    
}

// MARK: - UITableViewDataSource

extension OrdersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ordersView.tableView.dequeueReusableCell(
            withIdentifier: OrderTableViewCell.identifier,
            for: indexPath
        ) as? OrderTableViewCell else { return UITableViewCell() }
        
        cell.configure(order: model.orders[indexPath.row])
        
        return cell
    }
    
}
