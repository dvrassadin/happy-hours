//
//  CreateUser.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 2/5/24.
//

import Foundation

struct CreateUser: Encodable {
    
    let email: String
    let password: String
    let passwordConfirm: String
    let name: String
    let dateOfBirth: Date
    
}
