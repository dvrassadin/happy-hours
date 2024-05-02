//
//  AuthorizationModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

protocol AuthorizationModelProtocol {
    
    func logIn(email: String, password: String) async throws
    func createUser(
        email: String,
        password: String,
        passwordConfirm: String,
        name: String,
        date: Date
    ) async throws
}
