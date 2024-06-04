//
//  Subscription.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 3/6/24.
//

import Foundation

struct Subscription: Decodable {
    
    let id: Int
    let plan: SubscriptionPlan
    let endDate: Date
    let isActive: Bool
    
}
