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
    private(set) var user: User?
    var avatarImage: UIImage? {
        get async {
            guard let url = user?.avatar,
                  let data = await networkService.getImageData(from: url),
                  let image = UIImage(data: data)
            else { return nil }
            return image
        }
    }
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Updating user
    
    func downloadUser() async throws {
        try await self.user = networkService.getUser(allowRetry: true)
    }
    
    func editUser(_ user: UserUpdate) async throws {
        do {
            try await networkService.editUser(user, allowRetry: true)
            try await self.user = networkService.getUser(allowRetry: true)
        } catch {
            throw error
        }
    }
    
    func updateAvatar() {
        
    }
    
    // MARK: Logout
    
    func logOut() async throws {
        try await networkService.logOut()
    }
    
}
