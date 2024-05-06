//
//  NetworkServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func logIn(_ logIn: LogIn) async throws
    func createUser(_ user: CreateUser) async throws
    func logOut() async throws
    func getRestaurants(limit: UInt, offset: UInt) async throws -> [Restaurant]
    func getImageData(from stringURL: String) async -> Data?
    func getUser() async throws -> User
    func editUser(_ user: UserUpdate) async throws
    
}
