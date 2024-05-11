//
//  MenuTableViewCellDelegate.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 11/5/24.
//

import Foundation

protocol MenuTableViewCellDelegate: AnyObject {
    
    func didClickOnCellWith(beverageID: Int)
    
}
