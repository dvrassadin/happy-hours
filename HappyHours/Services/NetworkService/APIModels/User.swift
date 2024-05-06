//
//  User.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 4/5/24.
//

import Foundation

struct User: Decodable {
    
    let email: String
    let name: String
    let dateOfBirth: Date?
    let avatar: String?
    
}
