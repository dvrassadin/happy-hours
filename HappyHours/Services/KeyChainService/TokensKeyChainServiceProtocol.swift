//
//  TokensKeyChainServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
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

protocol TokensKeyChainServiceProtocol {
    
    func save(token: String, type: JWTType)
//    func saveAccessToken(_ token: String)
//    func saveRefreshToken(_ token: String)
//    func getAccessToken() -> String?
//    func getRefreshToken() -> String?
    func getToken(_ type: JWTType) -> String?
    func deleteAllTokens()
    
}
