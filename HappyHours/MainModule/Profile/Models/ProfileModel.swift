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
    private var avatarImage: UIImage?
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
    
    func getAvatarImage() async -> UIImage? {
        if needUpdateAvatarImage {
            needUpdateAvatarImage = false
            guard let url = try? await user.avatar,
                  let data = await networkService.getImageData(from: url),
                  let image = UIImage(data: data)
            else { return nil }
            avatarImage = image
        }
        return avatarImage
    }
    
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
