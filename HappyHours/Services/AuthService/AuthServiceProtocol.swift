//
//  AuthServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 8/5/24.
//

import Foundation

protocol AuthServiceProtocol: Actor {
    
    var validAccessToken: String { get async throws }
    var validRefreshToken: String { get async throws }
    
    @discardableResult func refreshTokens() async throws -> Tokens
    func set(delegate: AuthServiceDelegate)
    func set(tokens: Tokens)
    func deleteTokens()
    
}
