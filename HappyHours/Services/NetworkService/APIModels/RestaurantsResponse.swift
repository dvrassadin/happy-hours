//
//  RestaurantsResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import UIKit
import CoreLocation

struct RestaurantsResponse: Decodable {
    
    let results: [Restaurant]

}

struct Restaurant: Decodable {
    
    let id: Int
    let name: String
    let description: String
    let phoneNumber: String?
    let logo: String?
    let address: String?
    private let happyhoursStart: String?
    var hhStart: String? {
        if let happyhoursStart {
            return String(happyhoursStart.prefix(5))
        }
        return nil
    }
    private let happyhoursEnd: String?
    var hhEnd: String? {
        if let happyhoursEnd {
            return String(happyhoursEnd.prefix(5))
        }
        return nil
    }
    let email: String?
    let feedbackCount: Int
    
    private let location: Location?
    var locationCoordinate: CLLocationCoordinate2D? {
        if let latitude = location?.coordinates.last, let longitude = location?.coordinates.first {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    private struct Location: Decodable {
        let coordinates: [Double]
    }
    
}
