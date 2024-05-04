//
//  ProfileModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import Foundation

protocol ProfileModelProtocol {
    
    var user: User { get }
    
    func updateUser(_ user: User)
    
    func logOut() async throws
}
