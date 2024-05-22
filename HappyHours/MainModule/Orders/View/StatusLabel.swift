//
//  StatusLabel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/5/24.
//

import UIKit

final class StatusLabel: UILabel {
    
    // MARK: Properties
    
    private let verticalInset: CGFloat = 3
    private let horizontalInset: CGFloat = 9
    
    // MARK: Increase space around text
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + horizontalInset * 2,
            height: size.height + verticalInset * 2
        )
    }
    
    override var bounds: CGRect {
         didSet {
             preferredMaxLayoutWidth = bounds.width - horizontalInset * 2
         }
     }
    
}
