//
//  SearchMode.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 26/4/24.
//

import Foundation

enum SearchMode: Int, CaseIterable {
    case beverages
    case restaurants
    
    var name: String {
        switch self {
        case .beverages:
            String(localized: "Beverages")
        case .restaurants:
            String(localized: "Restaurants")
        }
    }
}
