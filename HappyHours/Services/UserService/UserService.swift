//
//  UserService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 5/6/24.
//

import Foundation

actor UserService: UserServiceProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    private var needUpdateUser = true
    private var user: User?
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    // MARK: Get updated subscription
    
    func getUser() async throws -> User {
        if needUpdateUser {
            user = try await networkService.getUser(allowRetry: true)
        }
        needUpdateUser = false
        if let user {
            return user
        } else {
            throw UserError.noUser
        }
    }
    
    func setNeedUpdateUser() {
        needUpdateUser = true
    }
    
}
