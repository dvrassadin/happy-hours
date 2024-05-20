//
//  BeverageView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/5/24.
//

import UIKit

final class BeverageView: UIView {

    // MARK: UI components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 2
//        label.text = "Bublik"
        return label
    }()
    
    private let beverageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 2
//        label.text = "Honey lemon tea"
        return label
    }()
    
    private let beverageCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
//        label.text = "Tea"
        return label
    }()
    
    private let beverageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
//        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        return label
    }()
    
    private let beveragePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
//        label.text = "250 som"
        return label
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
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(restaurantNameLabel)
        contentView.addSubview(beverageNameLabel)
        contentView.addSubview(beverageCategoryLabel)
        contentView.addSubview(beverageDescriptionLabel)
        contentView.addSubview(beveragePriceLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                restaurantNameLabel.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: 5
                ),
                restaurantNameLabel.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -15
                ),
                
                beverageNameLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 5),
                beverageNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
                beverageNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
                
                beverageCategoryLabel.topAnchor.constraint(equalTo: beverageNameLabel.bottomAnchor, constant: 5),
                beverageCategoryLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beverageCategoryLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                beverageDescriptionLabel.topAnchor.constraint(equalTo: beverageCategoryLabel.bottomAnchor, constant: 10),
                beverageDescriptionLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beverageDescriptionLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                beveragePriceLabel.topAnchor.constraint(equalTo: beverageDescriptionLabel.bottomAnchor, constant: 10),
                beveragePriceLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beveragePriceLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                beveragePriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            ]
        )
    }
    
    func setUpBeverage(_ beverage: Beverage) {
        restaurantNameLabel.text = beverage.establishment
        beverageNameLabel.text = beverage.name
        beverageCategoryLabel.text = beverage.category
        beverageDescriptionLabel.text = beverage.description
        beveragePriceLabel.text = "\(beverage.price) som"
    }
    
}
