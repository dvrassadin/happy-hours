//
//  ProfileModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class ProfileModel: ProfileModelProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    private let userService: UserServiceProtocol
    private let subscriptionService: SubscriptionServiceProtocol
//    private(set) var user: User?
    var user: User {
        get async throws {
            try await userService.getUser()
        }
    }
//    private var avatarImage: UIImage? {
//        get async {
//            guard let url = try? await user.avatar,
//                  let data = await networkService.getImageData(from: url),
//                  let image = UIImage(data: data)
//            else { return nil }
//            return image
//        }
//    }
    private var avatarImage: UIImage?
    private var needUpdateAvatarImage: Bool = true
//    private(set) var avatarImage: UIImage?
    
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
    
//    func downloadUser() async throws {
//        try await self.user = networkService.getUser(allowRetry: true)
//    }
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
//        do {
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
//            try await self.user = networkService.getUser(allowRetry: true)
//        } catch {
//            throw error
//        }
    }
    
    // MARK: Logout
    
    func logOut() async throws {
        try await networkService.logOut()
    }
    
}
