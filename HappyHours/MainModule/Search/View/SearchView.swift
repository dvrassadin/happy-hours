//
//  SearchView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 24/4/24.
//

import UIKit
import SwiftUI
import MapKit

final class SearchView: UIView {
    
    // MARK: Properties
    
    private(set) var searchMode = SearchMode.beverages {
        didSet {
            changeSelectedView()
            delegate?.searchModeHasChanged(searchMode)
            endEditing(true)
        }
    }
    private var addedID = Set<Int>()
    
    weak var delegate: SearchViewDelegate?
    
    // MARK: UI components
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.tintColor = .main
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = String(localized: "Search")
        searchBar.searchTextField.textColor = .mainText
        return searchBar
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: SearchMode.allCases.map({ $0.name }))
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .main
        return segmentedControl
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            BeverageTableViewCell.self,
            forCellReuseIdentifier: BeverageTableViewCell.identifier
        )
        tableView.backgroundColor = .background
        tableView.allowsSelection = true
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.register(
            RestaurantMarkerView.self,
            forAnnotationViewWithReuseIdentifier: RestaurantMarkerView.identifier
        )
        if #available(iOS 17.0, *) {
            mapView.showsUserTrackingButton = true
        }
        mapView.tintColor = .main
        return mapView
    }()
    
    private var nothingFoundStateView = NothingFoundStateView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .main
        return activityIndicator
    }()
    
    let footerActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .main
        return activityIndicator
    }()

    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        addSubviews()
        setUpConstraints()
        segmentedControl.selectedSegmentIndex = searchMode.rawValue
        changeSelectedView()
        setUpUserInteraction()
    }
    
    private func addSubviews() {
        addSubview(searchBar)
        addSubview(segmentedControl)
        addSubview(tableView)
        addSubview(mapView)
        addSubview(activityIndicator)
        tableView.backgroundView = nothingFoundStateView
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                
                segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                Constraints.textFieldAndButtonWidthConstraint(for: segmentedControl, on: self),
                segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                tableView.topAnchor.constraint(
                    equalTo: segmentedControl.bottomAnchor,
                    constant: 5
                ),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                mapView.topAnchor.constraint(equalTo: tableView.topAnchor),
                mapView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                nothingFoundStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
                nothingFoundStateView.centerYAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.centerYAnchor
                ),
                
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualTo: nothingFoundStateView.bottomAnchor
                )
            ]
        )
    }
    
    // MARK: User interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    private func setUpUserInteraction() {
        segmentedControl.addAction(UIAction { [weak self] _ in
            guard let self,
                  let searchMode = SearchMode(rawValue: self.segmentedControl.selectedSegmentIndex)
            else { return }
            self.searchMode = searchMode
        }, for: .valueChanged)
    }
    
    private func changeSelectedView() {
        switch searchMode {
        case .beverages:
            mapView.isHidden = true
            tableView.isHidden = false
        case .restaurants:
            mapView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func showNothingFoundState() {
        tableView.backgroundView?.isHidden = false
    }
    
    func removeNothingFoundState() {
        tableView.backgroundView?.isHidden = true
    }
    
    // MARK: Setting up map
    
    func setUpUsersRegion(
        location: CLLocationCoordinate2D,
        regionRadius: CLLocationDistance = 2000
    ) {
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(region, animated: true)
    }
    
    func addNewMapAnnotations(restaurants: [Restaurant]) {
        mapView.removeAnnotations(mapView.annotations)
        addedID.removeAll()
        restaurants.forEach { restaurant in
            addMapAnnotation(restaurant: restaurant)
        }
    }
    
    /// Adds a restaurant if it was not added on the map. Use it when the map is moving.
    /// - Parameter restaurant: The new restaurant to display in the map view.
    func addMapAnnotation(restaurant: Restaurant) {
        guard let coordinate = restaurant.locationCoordinate,
              !addedID.contains(restaurant.id)
        else { return }
        
        let annotation: RestaurantAnnotation
        if let hhStart = restaurant.hhStart, let hhEnd = restaurant.hhEnd {
            annotation = RestaurantAnnotation(
                title: restaurant.name,
                subtitle: "\(hhStart) – \(hhEnd)",
                coordinate: coordinate,
                restaurantID: restaurant.id
            )
        } else {
            annotation = RestaurantAnnotation(
                title: restaurant.name,
                subtitle: nil,
                coordinate: coordinate,
                restaurantID: restaurant.id
            )
        }
        mapView.addAnnotation(annotation)
        addedID.insert(restaurant.id)
    }
    
}
