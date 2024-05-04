//
//  Restaurant.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import UIKit

struct RestaurantsResponse: Decodable {
    
    let results: [Restaurant]
    
}

struct Restaurant: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let logo: String
    let address: String
    let happyhoursStart: String
    let happyhoursEnd: String
    
}

//struct Restaurant {
//    let name: String
//    let hours: String
//    let address: String
//    let image: UIImage
//}
//
//extension Restaurant {
//    static let example = [
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        ),
//        Restaurant(
//            name: "Chicken Star",
//            hours: "14 – 16",
//            address: "Erkindik 36 / Toktogula, Bishkek, Kyrgyzstan",
//            image: .Restaurants.chickenStar
//        )
//    ]
//}
