//
//  ProfileModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import Foundation

final class ProfileModel: ProfileModelProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    private(set) var user: User = User.example
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Updating user
    
    func updateUser(_ user: User) {
        self.user = user
    }
    
    // MARK: Logout
    
    func logOut() async throws {
        try await networkService.logOut()
    }
    
}
