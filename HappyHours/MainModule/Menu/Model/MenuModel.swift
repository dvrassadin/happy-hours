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
    private(set) var restaurant: Restaurant
    private(set) var menu: [(category: String, beverages: [Beverage])] = []
    private var _logoImage: UIImage?
    var logoImage: UIImage? {
        get async {
            if let logoImage = _logoImage {
                return logoImage
            } else if let logoImageString = restaurant.logo,
                      let logoImageData = await networkService.getImageData(from: logoImageString),
                      let logoImage = UIImage(data: logoImageData) {
                return logoImage
            }
            return nil
        }
    }
    
    // MARK: lifecycle
    
    init(restaurant: Restaurant, logoImage: UIImage?, networkService: NetworkServiceProtocol) {
        self.restaurant = restaurant
        _logoImage = logoImage
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
    
    // MARK: Make order
    
    func makeOrder(_ order: PlaceOrder) async throws {
        try await networkService.makeOrder(order, allowRetry: true)
    }
    
}
