//
//  NothingFoundStateView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/4/24.
//

import UIKit

final class NothingFoundStateView: UIStackView {

    // MARK: UI components
    
    private let imageView: UIImageView = {
        let image = UIImage(systemName: "magnifyingglass")?
            .withTintColor(.TextField.text, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Nothing Found")
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .mainText
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "Enter the name of the establishment you want to find.")
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .TextField.text
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        spacing = 10
        addSubviews()
        setUpConstraints()
    }
    
    private func addSubviews() {
        addArrangedSubview(imageView)
        addArrangedSubview(titleLabel)
        addArrangedSubview(subtitleLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

}
