//
//  RestaurantsVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

// MARK: - RestaurantsVC class

final class RestaurantsVC: UIViewController {
    
    // MARK: Properties
    
    private let restaurantsView = RestaurantsView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = restaurantsView
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    RestaurantsVC()
}
