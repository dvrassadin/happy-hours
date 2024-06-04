//
//  SubscriptionPlan.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 3/6/24.
//

import Foundation

struct SubscriptionPlan: Decodable {
    
    let id: Int
    let name: String
    let duration: String
    let price: String
    let description: String
    let freeTrialDays: Int
    
}
