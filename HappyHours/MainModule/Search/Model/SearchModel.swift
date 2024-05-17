//
//  SearchModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 14/5/24.
//

import Foundation

final class SearchModel: SearchModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private(set) var restaurants: [Restaurant] = []
    private(set) var beverages: [Beverage] = []
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Update restaurant
    
    func updateRestaurants(latitude: Double, longitude: Double, metersRadius: Int) async throws {
        restaurants = try await networkService.getRestaurants(
            latitude: latitude,
            longitude: longitude,
            metersRadius: metersRadius,
            allowRetry: true
        )
    }
    
    func updateRestaurants(search: String) async throws {
        restaurants = try await networkService.getRestaurants(
            limit: 100,
            offset: 0,
            search: search,
            allowRetry: true
        )
    }
    
    func getRestaurant(id: Int) async throws -> Restaurant {
        try await networkService.getRestaurant(id: id, allowRetry: true)
    }
    
    // MARK: Update beverages
    
    func updateBeverages(search: String) async throws {
        beverages = try await networkService.getBeverages(
            limit: 100,
            offset: 0,
            search: search,
            allowRetry: true
        )
    }
    
}
