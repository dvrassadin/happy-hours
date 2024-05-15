//
//  RestaurantAnnotation.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/5/24.
//

import MapKit

final class RestaurantAnnotation: NSObject, MKAnnotation {
    
    // MARK: Properties
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let restaurantID: Int
    
    // MARK: Lifecycle
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, restaurantID: Int) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.restaurantID = restaurantID
        super.init()
    }
    
}
