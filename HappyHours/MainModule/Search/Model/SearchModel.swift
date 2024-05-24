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
    private var countOfAllBeverages: Int = 0
    
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
    
    func updateBeverages(search: String? = nil, append: Bool = false) async throws {
        if append && beverages.count >= countOfAllBeverages { return }
        
        let limit: UInt = 50
        
        if append {
            let beverageResponse = try await networkService.getBeverages(
                limit: limit,
                offset: UInt(beverages.count),
                search: search,
                allowRetry: true
            )
            beverages.append(contentsOf: beverageResponse.results)
        } else {
            let beverageResponse = try await networkService.getBeverages(
                limit: limit,
                offset: 0,
                search: search,
                allowRetry: true
            )
            beverages = beverageResponse.results
            countOfAllBeverages = beverageResponse.count
        }
    }
    
}
