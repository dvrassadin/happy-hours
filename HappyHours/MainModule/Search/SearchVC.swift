//
//  SearchVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/4/24.
//

import UIKit

final class SearchVC: UIViewController {
    
    // MARK: Properties
    
    private lazy var searchView = SearchView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = searchView
    }

}
