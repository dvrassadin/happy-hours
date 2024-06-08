//
//  SubscriptionModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/6/24.
//

import Foundation

final class SubscriptionModel: SubscriptionModelProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    private let subscriptionService: SubscriptionServiceProtocol
    private(set) var subscriptionPlans: [SubscriptionPlan] = []
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol, subscriptionService: SubscriptionServiceProtocol) {
        self.networkService = networkService
        self.subscriptionService = subscriptionService
    }
    
    // MARK: Update subscriptions
    
    func updateSubscription() async throws {
        subscriptionPlans = try await networkService.getSubscriptionPlans(allowRetry: true)
    }
}
