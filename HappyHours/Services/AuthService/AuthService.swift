//
//  AuthService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/5/24.
//

import Foundation

actor AuthService: AuthServiceProtocol {
    
    // MARK: Properties
    
    private let keyChainService: KeyChainServiceProtocol
    private weak var delegate: AuthServiceDelegate?
    private var refreshTask: Task<Tokens, Error>?
    
    private var accessToken: String? {
        get { keyChainService.getToken(.access) }
        set {
            if let newValue {
                keyChainService.save(token: newValue, type: .access)
            }
        }
    }
    
    private var refreshToken: String? {
        get { keyChainService.getToken(.refresh) }
        set {
            if let newValue {
                keyChainService.save(token: newValue, type: .refresh)
            }
        }
    }
    
    var validAccessToken: String {
        get async throws {
            if let handle = refreshTask {
                return try await handle.value.access
            }
            
            guard let accessToken else { throw AuthError.missingToken }
            
            return accessToken
        }
    }
    
    var validRefreshToken: String {
        get async throws {
            guard let refreshToken else { throw AuthError.missingToken }
            
            return refreshToken
        }
    }
    
    // MARK: Lifecycle
    
    init(keyChainService: KeyChainServiceProtocol) {
        self.keyChainService = keyChainService
    }
    
    func set(delegate: AuthServiceDelegate) {
        self.delegate = delegate
    }
    
    // MARK: Refresh tokens
    
    func set(tokens: Tokens) {
        accessToken = tokens.access
        refreshToken = tokens.refresh
    }
    
    func deleteTokens() {
        keyChainService.deleteAllTokens()
    }
    
    func refreshTokens() async throws -> Tokens {
        if let refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task { () throws -> Tokens in
            defer { refreshTask = nil }
            
            guard let delegate else { throw AuthError.noDelegate }
            
            let tokens = try await delegate.refreshTokens(refreshToken: validRefreshToken)
            
            accessToken = tokens.access
            self.refreshToken = tokens.refresh
            
            return tokens
        }
        
        self.refreshTask = task
        
        return try await task.value
    }
    
}
