//
//  ProfileModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class ProfileModel: ProfileModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private let userService: UserServiceProtocol
    let subscriptionService: SubscriptionServiceProtocol
    var user: User {
        get async throws {
            try await userService.getUser()
        }
    }
    var avatarImage: UIImage? {
        get async {
            if let stringURL = try? await user.avatar, let url = URL(string: stringURL) {
                return await networkService.getImage(from: url)
            }
            return nil
        }
    }
    private var needUpdateAvatarImage: Bool = true
    var subscription: Subscription? {
        get async throws {
            try await subscriptionService.getSubscription()
        }
    }
    var isSubscriptionActive: Bool {
        get async throws {
            guard let subscription = try await subscriptionService.getSubscription() else {
                return false
            }
            return subscription.isActive && subscription.endDate > .now
        }
    }
    
    
    // MARK: Lifecycle
    
    init(
        networkService: NetworkServiceProtocol,
        userService: UserServiceProtocol,
        subscriptionService: SubscriptionServiceProtocol
    ) {
        self.networkService = networkService
        self.userService = userService
        self.subscriptionService = subscriptionService
    }
    
    // MARK: Updating user
    
    func editUser(imageData: Data?, name: String?, dateOfBirth: Date?) async throws {
        if let _ = imageData {
            needUpdateAvatarImage = true
        }
        try await networkService.editUser(
            imageData: imageData,
            name: name,
            dateOfBirth: dateOfBirth,
            allowRetry: true
        )
        await userService.setNeedUpdateUser()
    }
    
    // MARK: Logout
    
    func logOut() async throws {
        try await networkService.logOut()
    }
    
}
