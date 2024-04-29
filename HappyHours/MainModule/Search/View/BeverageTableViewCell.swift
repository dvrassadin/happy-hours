//
//  BeverageTableViewCell.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 26/4/24.
//

import UIKit

final class BeverageTableViewCell: UITableViewCell {

    // MARK: Properties
    
    static let identifier = "BeverageCell"
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set up UI
    
    private func setUpUI() {
        backgroundColor = .background
    }

}
