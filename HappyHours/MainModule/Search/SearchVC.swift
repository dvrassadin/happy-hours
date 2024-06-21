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
    
    private lazy var searchView = SearchView()
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    private let model: SearchModelProtocol
    private let userService: UserServiceProtocol
    private var searchText: String?
    private var isLoadingBeverages = false
    private var isFiltering = false
    private var filteredBeverages: [Beverage] {
        isFiltering ? model.beverages.filter { $0.availabilityStatus } : model.beverages
    }
    
    // MARK: Navigation bar items
    
    private lazy var rightBarButton = UIBarButtonItem(
        title: "All",
        style: .plain,
        target: self,
        action: #selector(filterBeverages)
    )

    // MARK: Lifecycle
    
    init(model: SearchModelProtocol, userService: UserServiceProtocol) {
        self.model = model
        self.userService = userService
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
        searchView.searchBar.delegate = self
        searchView.mapView.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
        searchView.delegate = self
        searchView.searchBar.searchTextField.delegate = self
        updateBeverages()
        setUpUserInteraction()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if searchView.searchMode == .beverages {
            tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.searchController = nil
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: User interaction
    
    private func setUpUserInteraction() {
        searchView.mapView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: searchView.searchBar,
                action: #selector(searchView.endEditing)
            )
        )
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
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.getRestaurantsServerError)
            }
        }
    }
    
    private func updateRestaurants(search: String) async {
        do {
            try await model.updateRestaurants(search: search)
            searchView.addNewMapAnnotations(restaurants: model.restaurants)
        } catch AuthError.invalidToken {
            logOutWithAlert()
        } catch {
            showAlert(.getRestaurantsServerError)
        }
    }
    
    // MARK: Update beverages
    
    private func updateBeverages(search: String? = nil, append: Bool = false) {
        if !append { searchText = search }
        
        isLoadingBeverages = true
        
        if append {
            searchView.tableView.tableFooterView = searchView.footerActivityIndicator
            searchView.footerActivityIndicator.startAnimating()
        } else {
            searchView.removeNothingFoundState()
            searchView.activityIndicator.startAnimating()
        }
        
        Task {
            defer {
                searchView.activityIndicator.stopAnimating()
                searchView.footerActivityIndicator.stopAnimating()
                searchView.tableView.tableFooterView = nil
                isLoadingBeverages = false
            }
            do {
                try await model.updateBeverages(search: searchText, append: append)
                if model.beverages.isEmpty {
                    searchView.tableView.reloadData()
                    searchView.showNothingFoundState()
                } else {
                    searchView.removeNothingFoundState()
                    searchView.tableView.reloadData()
                }
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                searchView.showNothingFoundState()
                showAlert(.beveragesServerError)
            }
        }
    }
    
    @objc private func filterBeverages() {
        isFiltering.toggle()
        rightBarButton.title = String(localized: isFiltering ? "Available" : "All")
        searchView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beverageVC = BeverageVC(beverage: filteredBeverages[indexPath.row])
        beverageVC.sheetPresentationController?.prefersGrabberVisible = true
        beverageVC.sheetPresentationController?.detents = [.medium(), .large()]
        present(beverageVC, animated: true)
        searchView.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredBeverages.isEmpty {
            return 0
        } else {
            searchView.removeNothingFoundState()
            return filteredBeverages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BeverageTableViewCell.identifier,
            for: indexPath
        ) as? BeverageTableViewCell else { return UITableViewCell() }
        
//        var contentConfiguration = cell.defaultContentConfiguration()
        let beverage = filteredBeverages[indexPath.row]
//        contentConfiguration.text = beverage.name
//        contentConfiguration.secondaryText = beverage.establishment
//        cell.contentConfiguration = contentConfiguration
        cell.configure(beverage: beverage)
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate

extension SearchVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoadingBeverages else { return }

        if searchView.tableView.contentOffset.y >= (searchView.tableView.contentSize.height - searchView.tableView.frame.size.height) {
            updateBeverages(search: searchText, append: true)
        }
    }
    
}

// MARK: - SearchViewDelegate

extension SearchVC: SearchViewDelegate {
    
    func searchModeHasChanged(_ searchMode: SearchMode) {
        searchView.searchBar.text = nil
        switch searchMode {
        case .beverages:
            tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
            locationManager.stopUpdatingLocation()
        case .restaurants:
            tabBarController?.navigationItem.rightBarButtonItem = nil
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
        guard let text = searchView.searchBar.text, !text.isEmpty else { return }
        
        switch searchView.searchMode {
        case .beverages:
            updateBeverages(search: text)
        case .restaurants:
            Task {
                await updateRestaurants(search: text)
                searchView.mapView.showAnnotations(searchView.mapView.annotations, animated: true)
            }
        }
        searchView.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch searchView.searchMode {
        case .beverages:
            updateBeverages()
        case .restaurants:
            updateRestaurantsInRadius(searchView.mapView)
        }
        return true
    }
    
}

// MARK: - MKMapViewDelegate

extension SearchVC: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard !searchView.mapView.isHidden else { return }

        func updateMap() {
            NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(updateRestaurantsInRadius(_:)),
                object: searchView.mapView
            )
            perform(
                #selector(updateRestaurantsInRadius(_:)),
                with: searchView.mapView,
                afterDelay: 0.5
            )
        }
        if let text = searchView.searchBar.text {
            if text.isEmpty {
                updateMap()
            }
        } else {
            updateMap()
        }
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
            let menuVC = MenuVC(model: menuModel, userService: userService, areOrdersEnable: false)
            let navigationController = UINavigationController(rootViewController: menuVC)
            navigationController.navigationBar.tintColor = .main
            navigationController.sheetPresentationController?.prefersGrabberVisible = true
            present(navigationController, animated: true)
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
                    let menuVC = MenuVC(
                        model: menuModel,
                        userService: userService,
                        areOrdersEnable: false
                    )
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
