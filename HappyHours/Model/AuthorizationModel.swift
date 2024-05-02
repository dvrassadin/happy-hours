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
        do {
            try await networkService.login(.init(email: email, password: password))
            keyChainService.saveCredentials(email: email, password: password)
        } catch {
            throw error
        }
    }
    
    // MARK: Creating user
    
    func createUser(
        email: String,
        password: String,
        confirmPassword: String,
        name: String,
        date: Date
    ) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let newUser = Components.Schemas.ClientRegister(
            email: email.lowercased(),
            password: password,
            password_confirm: confirmPassword,
            name: name,
            date_of_birth: dateFormatter.string(from: date)
        )
        
        try await networkService.createUser(newUser)
    }

}
