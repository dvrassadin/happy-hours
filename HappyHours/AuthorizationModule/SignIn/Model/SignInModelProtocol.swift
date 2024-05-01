//
//  SignInModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

protocol SignInModelProtocol {
    
    func logIn(email: String, password: String) async throws
    
}
