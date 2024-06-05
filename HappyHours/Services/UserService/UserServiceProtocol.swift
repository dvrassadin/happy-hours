//
//  UserServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 5/6/24.
//

import Foundation

protocol UserServiceProtocol: Actor {
    
    func getUser() async throws -> User
    func setNeedUpdateUser()
    
}
