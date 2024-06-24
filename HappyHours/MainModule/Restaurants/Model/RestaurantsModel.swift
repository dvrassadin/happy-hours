//
//  RestaurantsModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class RestaurantsModel: RestaurantsModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private(set) var restaurants: [Restaurant] = []
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getRestaurants(limit: UInt, offset: UInt) async throws {
        restaurants = try await networkService.getRestaurants(
            limit: limit,
            offset: offset,
            search: nil,
            allowRetry: true
        )
    }
    
    func getImage(from url: URL) async -> UIImage? {
        await networkService.getImage(from: url)
    }
    
}
