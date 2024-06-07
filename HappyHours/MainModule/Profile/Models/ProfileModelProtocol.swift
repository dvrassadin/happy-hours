//
//  ProfileModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

protocol ProfileModelProtocol {
    
    var user: User { get async throws }

    func getAvatarImage() async -> UIImage?
    func logOut() async throws
    func editUser(imageData: Data?, name: String?, dateOfBirth: Date?) async throws
    
}
