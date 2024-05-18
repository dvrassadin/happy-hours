//
//  SearchModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 14/5/24.
//

import Foundation

protocol SearchModelProtocol {
    
    var networkService: NetworkServiceProtocol { get }
    var restaurants: [Restaurant] { get }
    var beverages: [Beverage] { get }
    
    func updateRestaurants(latitude: Double, longitude: Double, metersRadius: Int) async throws
    func updateRestaurants(search: String) async throws
    func getRestaurant(id: Int) async throws -> Restaurant
    func updateBeverages(search: String, append: Bool) async throws
    
}
