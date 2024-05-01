//
//  SignInModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

final class SignInModel: SignInModelProtocol {
    
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
}
