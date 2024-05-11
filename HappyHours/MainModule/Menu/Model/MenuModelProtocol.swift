//
//  MenuModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import Foundation

protocol MenuModelProtocol {
    
    var menu: [(category: String, beverages: [Beverage])] { get }
    
    func updateMenu(restaurantID: Int, limit: UInt, offset: UInt) async throws
    func makeOrder(_ order: Order) async throws
    
}
