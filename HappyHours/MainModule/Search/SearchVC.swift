//
//  SearchVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/4/24.
//

import UIKit
import CoreLocation
import MapKit

// MARK: - SearchVC class

final class SearchVC: UISearchController, AlertPresenter {
    
    // MARK: Properties
    
    private let beverages = ["Cola", "Beer", "Wine", "Apple juice", "Orange juice", "Tomato juice", "Sprite", "Pepsi", "Fanta", "Vodka", "Coffee", "Tea", "Greenfield", "Latte", "Americano", "7 up"]
    private var filteredBeverages = [String]()
    private lazy var searchView = SearchView()
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    private let model: SearchModelProtocol

    // MARK: Lifecycle
    
    init(model: SearchModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.searchController.searchResultsUpdater = self
        searchView.searchController.searchBar.delegate = self
        searchView.mapView.delegate = self
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
    
    // MARK: Update restaurants
    
    @objc private func updateRestaurantsInRadius(_ mapView: MKMapView) {
        let region = mapView.region
        let furthest = CLLocation(latitude: region.center.latitude + (region.span.latitudeDelta / 2),
                                  longitude: region.center.longitude + (region.span.longitudeDelta / 2))
        let center = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        let maxDistance = center.distance(from: furthest)
        Task {
            do {
                try await model.updateRestaurants(
                    latitude: region.center.latitude,
                    longitude: region.center.longitude,
                    metersRadius: Int(maxDistance)
                )
                model.restaurants.forEach { restaurant in
                    searchView.addMapAnnotation(restaurant: restaurant)
                }
            } catch {
                showAlert(.getRestaurantsServerError)
            }
        }
    }
    
    private func updateRestaurants(search: String) async {
        do {
            try await model.updateRestaurants(search: search)
            searchView.addNewMapAnnotations(restaurants: model.restaurants)
        } catch {
            showAlert(.getRestaurantsServerError)
        }
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

// MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchView.searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        Task {
            await updateRestaurants(search: text)
            searchView.mapView.showAnnotations(searchView.mapView.annotations, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateRestaurantsInRadius(searchView.mapView)
    }
    
}

// MARK: - MKMapViewDelegate
extension SearchVC: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard !searchView.mapView.isHidden, !searchView.searchController.isActive else { return }
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(updateRestaurantsInRadius(_:)),
            object: searchView.mapView
        )
        perform(#selector(updateRestaurantsInRadius(_:)), with: searchView.mapView, afterDelay: 0.75)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard annotation is RestaurantAnnotation,
              let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: RestaurantMarkerView.identifier
              ) as? RestaurantMarkerView else { return nil }
        
        annotationView.glyphImage = UIImage(systemName: "storefront.fill")
        
        return annotationView
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let restaurantMarkerView = view as? RestaurantMarkerView,
              let restaurantAnnotation = view.annotation as? RestaurantAnnotation
        else { return }
        
        if let restaurant = model.restaurants.first(where: {
            $0.id == restaurantAnnotation.restaurantID
        }) {
            let menuModel = MenuModel(
                restaurant: restaurant,
                logoImage: nil,
                networkService: model.networkService
            )
            let menuVC = MenuVC(model: menuModel, areOrdersEnable: false)
            present(menuVC, animated: true)
        } else {
            restaurantMarkerView.startActivityIndicator()
            Task {
                do {
                    let restaurant = try await model.getRestaurant(
                        id: restaurantAnnotation.restaurantID
                    )
                    let menuModel = MenuModel(
                        restaurant: restaurant,
                        logoImage: nil,
                        networkService: model.networkService
                    )
                    let menuVC = MenuVC(model: menuModel, areOrdersEnable: false)
                    present(menuVC, animated: true)
                    restaurantMarkerView.stopActivityIndicator()
                } catch {
                    restaurantMarkerView.stopActivityIndicator()
                    showAlert(.getRestaurantServerError)
                }
            }
        }
    }
    
}
