//
//  CredentialsKeyChainServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

protocol CredentialsKeyChainServiceProtocol {
    
    func saveCredentials(email: String, password: String)
    func getCredentials() -> (email: String, password: String)?
    
}
