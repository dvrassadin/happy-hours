//
//  OrdersView.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 21/5/24.
//

import UIKit

final class OrdersView: UIView {

    // MARK: UI components
    
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
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }

}
