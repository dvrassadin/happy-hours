//
//  ProfileModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

protocol ProfileModelProtocol {
    
    var networkService: NetworkServiceProtocol { get }
    var subscriptionService: SubscriptionServiceProtocol { get }
    var user: User { get async throws }
    var subscription: Subscription? { get async throws }
    var isSubscriptionActive: Bool { get async throws }

    func getAvatarImage() async -> UIImage?
    func logOut() async throws
    func editUser(imageData: Data?, name: String?, dateOfBirth: Date?) async throws
    
}
