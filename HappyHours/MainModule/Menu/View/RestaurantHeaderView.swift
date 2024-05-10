//
//  RestaurantHeaderView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class RestaurantHeaderView: UIView {
    
    // MARK: UI components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .systemMint
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .mainText
        label.numberOfLines = 0
//        label.text = "Very long long long long restaurant name"
        return label
    }()
    
//    private let addressLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .preferredFont(forTextStyle: .subheadline)
//        label.textColor = .mainText
//        label.numberOfLines = 0
//        label.text = "Abdumomunova St., 220 A, Bishkek 720000 Kyrgyzstan"
//        label.textAlignment = .right
//        return label
//    }()
    
    private let addressTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.textColor = .mainText
//        textView.text = "Abdumomunova St., 220 A, Bishkek 720000 Kyrgyzstan"
        textView.textAlignment = .right
        textView.dataDetectorTypes = .address
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .mainText
        label.numberOfLines = 0
        return label
    }()
    
    private let happyHoursLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .mainText
        label.numberOfLines = 0
        label.textColor = .main
        return label
    }()
    
    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .mainText
        label.numberOfLines = 0
        label.text = String(localized: "Contacts:")
        return label
    }()
    
    private let phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.dataDetectorTypes = .phoneNumber
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textColor = .mainText
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let emailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textColor = .mainText
        textView.isSelectable = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .mainText
        label.text = String(localized: "Menu")
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
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(addressTextView)
        addSubview(descriptionLabel)
        addSubview(happyHoursLabel)
        addSubview(contactsLabel)
        addSubview(phoneNumberTextView)
        addSubview(emailTextView)
        addSubview(menuLabel)
    }
    
    private func setUpConstraints() {
        let leadingAnchor = logoImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10)
        leadingAnchor.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            leadingAnchor,
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            
            addressTextView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            addressTextView.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            addressTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: addressTextView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            happyHoursLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            happyHoursLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            happyHoursLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            contactsLabel.topAnchor.constraint(equalTo: happyHoursLabel.bottomAnchor, constant: 10),
            contactsLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            
            phoneNumberTextView.topAnchor.constraint(equalTo: contactsLabel.topAnchor),
            phoneNumberTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            emailTextView.topAnchor.constraint(equalTo: phoneNumberTextView.bottomAnchor, constant: 10),
            emailTextView.trailingAnchor.constraint(equalTo: phoneNumberTextView.trailingAnchor),
            
            menuLabel.topAnchor.constraint(equalTo: emailTextView.bottomAnchor),
            menuLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            menuLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            menuLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func set(restaurant: Restaurant, logoImage: UIImage?) {
        if let logoImage {
            logoImageView.image = logoImage
        } else {
            logoImageView.image = UIImage(
                systemName: "storefront.fill"
            )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
        }
        nameLabel.text = restaurant.name
        addressTextView.text = restaurant.address
        descriptionLabel.text = restaurant.description
        if let hhStart = restaurant.happyhoursStart, let hhEnd = restaurant.happyhoursEnd {
            happyHoursLabel.text = String(localized: "Happy hours from \(hhStart) to \(hhEnd).")
        }
        phoneNumberTextView.text = restaurant.phoneNumber
        emailTextView.text = restaurant.email
//        layoutSubviews()
    }
    
//    func set(logo: UIImage?) {
//        if let logo {
//            logoImageView.image = logo
//        }
//    }
    
}
