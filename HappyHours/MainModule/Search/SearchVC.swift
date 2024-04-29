//
//  SearchVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/4/24.
//

import UIKit
import CoreLocation

// MARK: - SearchVC class

final class SearchVC: UISearchController {
    
    // MARK: Properties
    
    private let beverages = ["Cola", "Beer", "Wine", "Apple juice", "Orange juice", "Tomato juice", "Sprite", "Pepsi", "Fanta", "Vodka", "Coffee", "Tea", "Greenfield", "Latte", "Americano", "7 up"]
    private var filteredBeverages = [String]()
    private lazy var searchView = SearchView()
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    // MARK: Lifecycle
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchController.searchResultsUpdater = self
        searchView.tableView.dataSource = self
        searchView.delegate = self
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        tabBarController?.navigationItem.searchController = searchView.searchController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.searchController = nil
    }

}

// MARK: - UISearchResultsUpdating

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        switch searchView.searchMode {
        case .beverages:
            filteredBeverages = beverages.filter { $0.lowercased().contains(text.lowercased()) }
            searchView.tableView.reloadData()
        case .restaurants:
            break
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBeverages.isEmpty {
            searchView.showNothingFoundState()
            return 0
        } else {
            searchView.removeState()
            return filteredBeverages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BeverageTableViewCell.identifier,
            for: indexPath
        ) as? BeverageTableViewCell else { return UITableViewCell() }
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = filteredBeverages[indexPath.row]
        contentConfiguration.secondaryText = "KFC"
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
}

// MARK: - SearchViewDelegate

extension SearchVC: SearchViewDelegate {
    
    func searchModeHasChanged(_ searchMode: SearchMode) {
        switch searchMode {
        case .beverages:
            locationManager.stopUpdatingLocation()
        case .restaurants:
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
            guard let location = locationManager.location else { return }
            searchView.setUpUsersRegion(location: location.coordinate)
        }
    }
    
}
