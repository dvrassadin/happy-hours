//
//  BeverageVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/5/24.
//

import UIKit

// MARK: - BeverageVC class

final class BeverageVC: UIViewController {

    // MARK: Properties
    
    private let beverage: Beverage
    private lazy var beverageView = BeverageView()
    
    // MARK: Lifecycle
    
    init(beverage: Beverage) {
        self.beverage = beverage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = beverageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beverageView.setUpBeverage(beverage)
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    
    BeverageVC(
        beverage: Beverage(
            id: 1,
            name: "Honey lemon tea",
            price: "250",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            availabilityStatus: false,
            category: "Tea",
            establishment: "Bublik"
        )
    )
    
}
