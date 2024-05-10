//
//  AuthServiceDelegate.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 9/5/24.
//

import Foundation

protocol AuthServiceDelegate: AnyObject {
    
    func refreshTokens(refreshToken: String) async throws -> Tokens
    
}
