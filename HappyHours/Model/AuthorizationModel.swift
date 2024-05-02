//
//  AuthorizationModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

final class AuthorizationModel: AuthorizationModelProtocol {
    
    // MARK: Properties
    
    private let networkService: NetworkServiceProtocol
    private let keyChainService: CredentialsKeyChainServiceProtocol = KeyChainService()
    
    // MARK: Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: Log in
    
    func logIn(email: String, password: String) async throws {
        let logIn = LogIn(email: email.lowercased(), password: password)
        try await networkService.logIn(logIn)
    }
    
    // MARK: Creating user
    
    func createUser(
        email: String,
        password: String,
        passwordConfirm: String,
        name: String,
        date: Date
    ) async throws {
        let newUser = CreateUser(
            email: email.lowercased(),
            password: password,
            passwordConfirm: passwordConfirm,
            name: name,
            dateOfBirth: date
        )
        try await networkService.createUser(newUser)
    }

}
