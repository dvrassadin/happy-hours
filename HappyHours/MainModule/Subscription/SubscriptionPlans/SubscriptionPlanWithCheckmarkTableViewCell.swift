//
//  SubscriptionPlanWithCheckmarkTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 10/6/24.
//

import UIKit

final class SubscriptionPlanWithCheckmarkTableViewCell: SubscriptionPlanBasicTableViewCell {
    
    // MARK: UI components
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Set up UI
    
    private func addSubviews() {
        
    }
    
}
