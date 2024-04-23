//
//  User.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

struct User {
    var name: String
    let email: String
    var birthday: Date
    let avatar: UIImage?
}

extension User {
    static var example = User(
        name: "Daniil",
        email: "daniil@rassadin.org",
        birthday: Date(
            timeIntervalSince1970: 582073205
        ),
        avatar: .daniil
    )
}
