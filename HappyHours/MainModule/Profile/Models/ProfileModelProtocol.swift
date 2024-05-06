//
//  ProfileModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

protocol ProfileModelProtocol {
    
    var user: User? { get }
    var avatarImage: UIImage? { get async }
    
    func downloadUser() async throws
    func logOut() async throws
    func editUser(_ user: UserUpdate) async throws
    
}
