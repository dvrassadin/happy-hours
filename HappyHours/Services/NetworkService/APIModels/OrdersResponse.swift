//
//  OrdersResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/5/24.
//

import Foundation

struct OrdersResponse: Decodable {
    
    let count: Int
    let results: [Order]
    
}

struct Order: Decodable {
    
    let id: Int
    let orderDate: Date
    let establishmentName: String
    let beverageName: String
    
    let status: Status
    enum Status: String, Decodable {
        case pending = "pending"
        case inPreparation = "in_preparation"
        case completed = "completed"
        case cancelled = "cancelled"
    }
    
}
