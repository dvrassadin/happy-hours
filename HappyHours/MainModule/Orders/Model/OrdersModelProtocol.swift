//
//  OrdersModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/5/24.
//

import Foundation

protocol OrdersModelProtocol {
    
    var orders: [Order] { get }
    
    func updateOrders(append: Bool) async throws
}
