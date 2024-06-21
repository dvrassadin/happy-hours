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
    
    private let beverageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 2
        return label
    }()
    
    private let beveragePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainText
        label.font = .systemFont(ofSize: 21)
        label.numberOfLines = 1
        return label
    }()
    
    private let beverageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let beverageCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let beverageStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .mainText
//        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 2
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
        contentView.addSubview(beverageNameLabel)
        contentView.addSubview(beveragePriceLabel)
        contentView.addSubview(beverageDescriptionLabel)
        contentView.addSubview(beverageCategoryLabel)
        contentView.addSubview(beverageStatusLabel)
        contentView.addSubview(restaurantNameLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                beverageNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor,constant: 20),
                beverageNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                beverageNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                
                beveragePriceLabel.topAnchor.constraint(equalTo: beverageNameLabel.bottomAnchor, constant: 10),
                beveragePriceLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beveragePriceLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                beverageDescriptionLabel.topAnchor.constraint(equalTo: beveragePriceLabel.bottomAnchor, constant: 10),
                beverageDescriptionLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beverageDescriptionLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                beverageCategoryLabel.topAnchor.constraint(equalTo: beverageDescriptionLabel.bottomAnchor, constant: 10),
                beverageCategoryLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beverageCategoryLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                beverageStatusLabel.topAnchor.constraint(equalTo: beverageCategoryLabel.bottomAnchor, constant: 10),
                beverageStatusLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                beverageStatusLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                
                restaurantNameLabel.topAnchor.constraint(equalTo: beverageStatusLabel.bottomAnchor, constant: 10),
                restaurantNameLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
                restaurantNameLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
                restaurantNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//                beverageCategoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
                
//                restaurantNameLabel.topAnchor.constraint(
//                    equalTo: contentView.topAnchor,
//                    constant: 5
//                ),
//                restaurantNameLabel.trailingAnchor.constraint(
//                    equalTo: contentView.trailingAnchor,
//                    constant: -15
//                ),
//                
//                beverageNameLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 5),
//                beverageNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//                beverageNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
//                
//                beverageCategoryLabel.topAnchor.constraint(equalTo: beverageNameLabel.bottomAnchor, constant: 5),
//                beverageCategoryLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
//                beverageCategoryLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
//                
//                beverageDescriptionLabel.topAnchor.constraint(equalTo: beverageCategoryLabel.bottomAnchor, constant: 10),
//                beverageDescriptionLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
//                beverageDescriptionLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
//                
//                beveragePriceLabel.topAnchor.constraint(equalTo: beverageDescriptionLabel.bottomAnchor, constant: 10),
//                beveragePriceLabel.leadingAnchor.constraint(equalTo: beverageNameLabel.leadingAnchor),
//                beveragePriceLabel.trailingAnchor.constraint(equalTo: beverageNameLabel.trailingAnchor),
//                beveragePriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            ]
        )
    }
    
    func setUpBeverage(_ beverage: Beverage) {
//        restaurantNameLabel.text = beverage.establishment
        setRestaurantAttributedTitle(restaurant: beverage.establishment)
        beverageNameLabel.text = beverage.name
//        beverageCategoryLabel.text = beverage.category
        setCategoryAttributedTitle(category: beverage.category)
        beverageDescriptionLabel.text = beverage.description
        setStatusAttributedTitle(status: beverage.availabilityStatus)
        beveragePriceLabel.text = "\(beverage.price) KGS"
    }
    
    private func setCategoryAttributedTitle(category: String) {
        let attributedString = NSMutableAttributedString(
            string: String(localized: "Category: "),
            attributes: [.font: UIFont.systemFont(ofSize: 18),
                         .foregroundColor: UIColor.darkGray]
        )
        let categoryName = NSAttributedString(
            string: category,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedString.append(categoryName)
        beverageCategoryLabel.attributedText = attributedString
    }
    
    private func setStatusAttributedTitle(status: Bool) {
        let attributedString = NSMutableAttributedString(
            string: String(localized: "Status: "),
            attributes: [.font: UIFont.systemFont(ofSize: 18),
                         .foregroundColor: UIColor.darkGray]
        )
        let statusString = NSAttributedString(
            string: String(localized: status ? "Available" : "Unavailable"),
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedString.append(statusString)
        beverageStatusLabel.attributedText = attributedString
    }
    
    private func setRestaurantAttributedTitle(restaurant: String) {
        let attributedString = NSMutableAttributedString(
            string: String(localized: "Establishment: "),
            attributes: [.font: UIFont.systemFont(ofSize: 18),
                         .foregroundColor: UIColor.darkGray]
        )
        let categoryName = NSAttributedString(
            string: restaurant,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]
        )
        attributedString.append(categoryName)
        restaurantNameLabel.attributedText = attributedString
    }
    
}


