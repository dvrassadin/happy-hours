//
//  MenuModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class MenuModel: MenuModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private(set) var menu: [(category: String, beverages: [Beverage])] = []
    
    // MARK: lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Get menu
    
    func updateMenu(restaurantID: Int, limit: UInt, offset: UInt) async throws {
        let beverages = try await networkService.getMenu(
            restaurantID: restaurantID,
            limit: limit,
            offset: offset,
            allowRetry: true
        )
        menu = Dictionary(grouping: beverages) { $0.category }
            .map { (category: $0, beverages: $1) }
            .sorted { $0.category < $1.category }
    }
    
}
