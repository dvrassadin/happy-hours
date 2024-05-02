//
//  NetworkServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func logIn(logIn: LogIn) async throws
    func createUser() async throws
}
