//
//  RestaurantHeaderView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class RestaurantHeaderView: UIView {
    
    // MARK: Properties
    
    lazy var readMore = false
    private var wasAddedReadMore = false
    
    // MARK: UI components
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(
            systemName: "storefront.fill"
        )?.withTintColor(.TextField.placeholder, renderingMode: .alwaysOriginal)
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .mainText
        label.numberOfLines = 0
        return label
    }()
    
    private let addressTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.textColor = .mainText
        textView.textAlignment = .right
//        textView.dataDetectorTypes = .address
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .mainText
        label.numberOfLines = 3
        return label
    }()
    
    lazy var readMoreButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.title = "Read More"
        button.configuration?.baseForegroundColor = .main
        button.configuration?.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .caption1)
            return outgoing
        }
        button.configuration?.contentInsets = .zero
        return button
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
//        textView.dataDetectorTypes = .phoneNumber
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
//        textView.dataDetectorTypes = .link
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textColor = .mainText
        textView.isSelectable = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    let tabBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            MenuTabCollectionViewCell.self,
            forCellWithReuseIdentifier: MenuTabCollectionViewCell.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .background
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isLabelTextTruncated(descriptionLabel) && !wasAddedReadMore {
            addReadMoreButton()
        }
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
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
        addSubview(tabBarCollectionView)
    }
    
    private func setUpConstraints() {
        let leadingAnchor = logoImageView.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor,
            constant: 10
        )
        leadingAnchor.priority = UILayoutPriority(999)
        
        let happyHoursTop = happyHoursLabel.topAnchor.constraint(
            equalTo: descriptionLabel.bottomAnchor,
            constant: 10
        )
        happyHoursTop.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            leadingAnchor,
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            
            addressTextView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            addressTextView.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            addressTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
           
            descriptionLabel.topAnchor.constraint(equalTo: addressTextView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
//            happyHoursLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            happyHoursTop,
            happyHoursLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            happyHoursLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            contactsLabel.topAnchor.constraint(equalTo: happyHoursLabel.bottomAnchor, constant: 10),
            contactsLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            
            phoneNumberTextView.topAnchor.constraint(equalTo: contactsLabel.topAnchor),
            phoneNumberTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
           
            emailTextView.topAnchor.constraint(equalTo: phoneNumberTextView.bottomAnchor, constant: 10),
            emailTextView.trailingAnchor.constraint(equalTo: phoneNumberTextView.trailingAnchor),
            
            tabBarCollectionView.topAnchor.constraint(equalTo: emailTextView.bottomAnchor, constant: 5),
            tabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabBarCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            tabBarCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func set(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressTextView.text = restaurant.address
        descriptionLabel.text = restaurant.description
        if let hhStart = restaurant.hhStart, let hhEnd = restaurant.hhEnd {
            happyHoursLabel.text = String(localized: "Happy hours from \(hhStart) to \(hhEnd).")
        }
        phoneNumberTextView.text = restaurant.phoneNumber
        emailTextView.text = restaurant.email
    }
    
    func addReadMoreButton() {
        addSubview(readMoreButton)
        
        NSLayoutConstraint.activate([
            readMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            readMoreButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            happyHoursLabel.topAnchor.constraint(equalTo: readMoreButton.bottomAnchor, constant: 10)
        ])
        
        wasAddedReadMore = true
    }
    
    func isLabelTextTruncated(_ label: UILabel) -> Bool {
        guard let text = label.text, let font = label.font else { return false }
        
        let textAttributes: [NSAttributedString.Key: Any] = [.font: font]
        
        let boundingRect = text.boundingRect(
            with: CGSize(width: label.frame.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: textAttributes,
            context: nil
        )
        print(boundingRect.size.height)
        print(label.frame.height)
        return boundingRect.size.height > label.frame.height
    }
    
}
