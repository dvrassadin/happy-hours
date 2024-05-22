//
//  OrdersModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/5/24.
//

import Foundation

final class OrdersModel: OrdersModelProtocol {
    
    private(set) var orders: [Order] = []
    private var countOfAllOrders = 0
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Update orders
    
    func updateOrders(append: Bool = false) async throws {
        if append && orders.count >= countOfAllOrders { return }
        
        let limit: UInt = 50
        
        if append {
            let ordersResponse = try await networkService.getOrders(
                limit: limit,
                offset: UInt(orders.count),
                allowRetry: true
            )
            orders.append(contentsOf: ordersResponse.results)
        } else {
            let ordersResponse = try await networkService.getOrders(
                limit: limit,
                offset: 0,
                allowRetry: true
            )
            orders = ordersResponse.results
            countOfAllOrders = ordersResponse.count
        }
    }
    
}
