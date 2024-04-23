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
    
    private let model: RestaurantsModelProtocol
    private let restaurantsView = RestaurantsView()

    // MARK: Lifecycle
    
    init(model: RestaurantsModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        restaurantsView.tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = restaurantsView
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    RestaurantsVC(model: RestaurantsModel())
}

// MARK: - UITableViewDataSource

extension RestaurantsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RestaurantsTableViewCell.identifier,
            for: indexPath
        ) as? RestaurantsTableViewCell else { return UITableViewCell() }
        
        cell.configure(restaurant: model.restaurants[indexPath.row])
        return cell
    }
    
}
