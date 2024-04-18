//
//  RestaurantsVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class RestaurantsVC: UIViewController {
    
    // MARK: Properties
    
    private let restaurantsView = RestaurantsView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = restaurantsView
    }

}
