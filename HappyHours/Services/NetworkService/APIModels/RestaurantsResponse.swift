//
//  RestaurantsResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import UIKit

struct RestaurantsResponse: Decodable {
    
    let results: [Restaurant]

}

struct Restaurant: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let phoneNumber: String?
    let logo: String?
    let address: String?
    let happyhoursStart: String?
    let happyhoursEnd: String?
    let email: String?
    
}
