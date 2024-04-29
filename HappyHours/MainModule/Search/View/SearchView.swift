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
        }
    }
    
    weak var delegate: SearchViewDelegate?
    
    // MARK: UI components
    
    let searchController = UISearchController()
    
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
        return tableView
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.showsScale = true
        return mapView
    }()
    
    private var nothingFoundStateView = NothingFoundStateView()

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
        addSubview(segmentedControl)
        addSubview(tableView)
        addSubview(mapView)
        tableView.backgroundView = nothingFoundStateView
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                Constraints.textFieldAndButtonWidthConstraint(for: segmentedControl, on: self),
                segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                tableView.topAnchor.constraint(
                    equalTo: segmentedControl.bottomAnchor,
                    constant: 10
                ),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                mapView.topAnchor.constraint(equalTo: tableView.topAnchor),
                mapView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
                mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                nothingFoundStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
                nothingFoundStateView.centerYAnchor.constraint(
                    equalTo: safeAreaLayoutGuide.centerYAnchor
                ),
                
                keyboardLayoutGuide.topAnchor.constraint(
                    greaterThanOrEqualTo: nothingFoundStateView.bottomAnchor
                )
            ]
        )
    }
    
    // MARK: User interaction
    
    private func setUpUserInteraction() {
        segmentedControl.addAction(UIAction { [weak self] _ in
            guard let self,
                  let searchMode = SearchMode(rawValue: self.segmentedControl.selectedSegmentIndex)
            else { return }
            self.searchMode = searchMode
        }, for: .valueChanged)
        
        mapView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: searchController.searchBar,
                action: #selector(endEditing)
            )
        )
        
        tableView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: searchController.searchBar,
                action: #selector(endEditing)
            )
        )
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
        tableView.backgroundView = nothingFoundStateView
    }
    
    func removeState() {
        tableView.backgroundView = nil
    }
    
    // MARK: Setting up map
    
    func setUpUsersRegion(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapView.setRegion(region, animated: true)
    }
    
}
