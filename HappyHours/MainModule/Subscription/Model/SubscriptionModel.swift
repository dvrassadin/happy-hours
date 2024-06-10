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
    
    func updateSubscriptionPlans() async throws {
        subscriptionPlans = try await networkService.getSubscriptionPlans(allowRetry: true)
    }
    
    func createPayment(subscriptionPlanID: Int) async throws -> URL {
        try await networkService.createPayment(
            subscriptionPlanID: subscriptionPlanID,
            allowRetry: true
        ).approvalUrl
    }
    
    func updateSubscription() async {
        await subscriptionService.setNeedUpdateSubscription()
//        try await networkService.executePayment(paymentURL: paymentURL)
    }
    
    func createFreeTrial(subscriptionPlanID: Int) async throws {
        let freeTrial = FreeTrial(planId: subscriptionPlanID)
        try await networkService.createFreeTrial(freeTrial: freeTrial, allowRetry: true)
        await subscriptionService.setNeedUpdateSubscription()
    }
    
}
