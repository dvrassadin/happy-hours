//
//  Restaurant.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import Foundation

struct Restaurant: Decodable {
    let name: String
    let hours: String
}

extension Restaurant {
    static let example = [
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
        Restaurant(name: "Chicken Star", hours: "13 – 16"),
    ]
}
