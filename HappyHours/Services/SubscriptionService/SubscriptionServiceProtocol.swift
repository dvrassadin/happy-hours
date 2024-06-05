//
//  SubscriptionServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 4/6/24.
//

import Foundation

protocol SubscriptionServiceProtocol: Actor {
    
    var isSubscriptionActive: Bool { get async throws }
    
    func getSubscription() async throws -> Subscription?
    func setNeedUpdateSubscription()
}
