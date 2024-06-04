//
//  SubscriptionService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 4/6/24.
//

import Foundation

actor SubscriptionService: SubscriptionServiceProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    var needUpdateSubscription = true
    private var subscription: Subscription?
    var isSubscriptionActive: Bool {
        get async throws {
            guard let subscription = try await getSubscription() else { return false }
            return subscription.isActive && subscription.endDate > .now
        }
    }
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Get updated subscription
    
    func getSubscription() async throws -> Subscription? {
        if needUpdateSubscription {
            do {
                subscription = try await networkService.getActiveSubscription(allowRetry: true)
            } catch APIError.noActiveSubscription {
                needUpdateSubscription = false
                return nil
            }
        }
        needUpdateSubscription = false
        return subscription
    }
    
}
