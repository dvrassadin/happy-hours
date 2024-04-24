//
//  Constraints.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/4/24.
//

import UIKit

enum Constraints {
    
    static func spaceBeforeFirstElement(
        for bottomView: UIView,
        under topView: UIView
    ) -> NSLayoutConstraint {
        bottomView.topAnchor.constraint(
            equalToSystemSpacingBelow: topView.bottomAnchor,
            multiplier: 4
        )
    }
    
    static func topBetweenTextFieldsAndButtons(
        for bottomView: UIView,
        under topView: UIView
    ) -> NSLayoutConstraint {
        bottomView.topAnchor.constraint(
            equalToSystemSpacingBelow: topView.bottomAnchor,
            multiplier: 2
        )
    }
    
    static func textFieldAndButtonHeighConstraint(
        for firstView: UIView,
        on secondView: UIView
    ) -> NSLayoutConstraint {
        firstView.heightAnchor.constraint(
            equalTo: secondView.safeAreaLayoutGuide.heightAnchor,
            multiplier: 0.0542
        )
    }
    
    static func textFieldAndButtonWidthConstraint(
        for firstView: UIView,
        on secondView: UIView
    ) -> NSLayoutConstraint {
        firstView.widthAnchor.constraint(
            equalTo: secondView.safeAreaLayoutGuide.widthAnchor,
            multiplier: 0.6853
        )
    }
}
