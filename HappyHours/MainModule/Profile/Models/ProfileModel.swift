//
//  ProfileModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import Foundation

final class ProfileModel: ProfileModelProtocol {
    
    // MARK: Properties
    
    private(set) var user: User = User.example
    
    // MARK: Updating user
    
    func updateUser(_ user: User) {
        self.user = user
    }
    
}
