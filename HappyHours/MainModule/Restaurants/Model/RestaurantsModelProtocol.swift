//
//  MainModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

protocol RestaurantsModelProtocol {
    
    var restaurants: [Restaurant] { get }
    func getRestaurants(limit: UInt, offset: UInt) async throws
    func getLogo(stringURL: String) async -> UIImage?
    
}
