//
//  KeyChainServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/5/24.
//

import Foundation

enum JWTType: CaseIterable {
    
    case access
    case refresh
    
    var identifier: CFString {
        switch self {
        case .access: return "accessToken" as CFString
        case .refresh: return "refreshToken" as CFString
        }
    }
}

protocol KeyChainServiceProtocol {
    
    func save(token: String, type: JWTType)
    func getToken(_ type: JWTType) -> String?
    func deleteAllTokens()
    func saveCredentials(email: String, password: String)
    func getCredentials() -> (email: String, password: String)?
    
}
