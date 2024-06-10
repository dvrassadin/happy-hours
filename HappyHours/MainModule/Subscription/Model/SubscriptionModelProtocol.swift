//
//  SubscriptionModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/6/24.
//

import Foundation

protocol SubscriptionModelProtocol {
    
    var subscriptionPlans: [SubscriptionPlan] { get }
    
    func updateSubscriptionPlans() async throws
    func createPayment(subscriptionPlanID: Int) async throws -> URL
    func updateSubscription() async
    func createFreeTrial(subscriptionPlanID: Int) async throws
}
