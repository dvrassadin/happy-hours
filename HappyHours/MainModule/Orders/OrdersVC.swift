//
//  OrdersVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/5/24.
//

import UIKit

final class OrdersVC: UIViewController {

    // MARK: Properties
    
    private lazy var ordersView = OrdersView()
    private let model: OrdersModelProtocol
    
    // MARK: Lifecycle
    
    init(model: OrdersModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
