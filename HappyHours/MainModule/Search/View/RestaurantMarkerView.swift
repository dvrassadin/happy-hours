//
//  RestaurantMarkerView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 15/5/24.
//

import MapKit

final class RestaurantMarkerView: MKMarkerAnnotationView {
    
    // MARK: Properties
    
    static let identifier = "RestaurantMarkerView"
    
    // MARK: UI components
    
    private let button: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = .main
        button.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .main
        activityIndicator.frame = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        return activityIndicator
    }()
    
    // MARK: Lifecycle
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        canShowCallout = true
        rightCalloutAccessoryView = button
        glyphImage = UIImage(systemName: "storefront.fill")
    }
    
    func startActivityIndicator() {
        rightCalloutAccessoryView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        rightCalloutAccessoryView = button
    }
    
}
