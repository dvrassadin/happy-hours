//
//  RestaurantsVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

// MARK: - RestaurantsVC class

final class RestaurantsVC: UIViewController, AlertPresenter {
    
    // MARK: Properties
    
    private let model: RestaurantsModelProtocol
    private lazy var restaurantsView = RestaurantsView()

    // MARK: Lifecycle
    
    init(model: RestaurantsModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = restaurantsView
        restaurantsView.tableView.dataSource = self
        restaurantsView.tableView.delegate = self
        restaurantsView.tableView.refreshControl?.addTarget(
            self,
            action: #selector(updateRestaurants),
            for: .valueChanged
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRestaurants()
    }
    
    // MARK: Update restaurants
    
    @objc private func updateRestaurants() {
        Task {
            do {
                try await model.getRestaurants(limit: 100, offset: 0)
                restaurantsView.tableView.reloadData()
            } catch {
                showAlert(.getRestaurantsServerError)
            }
            restaurantsView.tableView.refreshControl?.endRefreshing()
        }
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        if let selectedIndexPath = restaurantsView.tableView.indexPathForSelectedRow {
//            restaurantsView.tableView.deselectRow(at: selectedIndexPath, animated: animated)
//        }
//    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    RestaurantsVC(model: RestaurantsModel(networkService: NetworkService()))
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
        
        let restaurant = model.restaurants[indexPath.row]
        
        cell.configure(restaurant: restaurant)
        Task {
            cell.configure(logo: await model.getLogo(stringURL: restaurant.logo))
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension RestaurantsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
