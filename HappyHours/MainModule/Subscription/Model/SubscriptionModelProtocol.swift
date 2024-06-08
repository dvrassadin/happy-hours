//
//  SubscriptionModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/6/24.
//

import Foundation

protocol SubscriptionModelProtocol {
    
    var subscriptionPlans: [SubscriptionPlan] { get }
    
    func updateSubscription() async throws
}
