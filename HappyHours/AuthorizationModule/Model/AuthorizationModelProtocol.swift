//
//  AuthorizationModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation

protocol AuthorizationModelProtocol {
    
    var resetEmail: String? { get }
    
    func logIn(email: String, password: String) async throws
    func createUser(
        email: String,
        password: String,
        passwordConfirm: String,
        name: String,
        date: Date
    ) async throws
    func sendEmailForOTC(_ email: String) async throws
    func sendOTC(_ code: String) async throws
    func setNewPassword(password: String, passwordConfirmation: String) async throws
    
}
