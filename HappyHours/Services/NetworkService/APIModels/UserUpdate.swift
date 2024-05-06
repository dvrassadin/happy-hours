//
//  UserUpdate.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 6/5/24.
//

import Foundation

struct UserUpdate: Encodable {
    
    let name: String
    let dateOfBirth: Date
    let avatar: Data?
    
}
