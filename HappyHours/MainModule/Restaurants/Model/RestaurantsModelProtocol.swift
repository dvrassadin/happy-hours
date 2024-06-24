//
//  MainModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

protocol RestaurantsModelProtocol {
    
    var networkService: NetworkServiceProtocol { get }
    var restaurants: [Restaurant] { get }
    
    func getRestaurants(limit: UInt, offset: UInt) async throws
    func getImage(from url: URL) async -> UIImage?
    
}
