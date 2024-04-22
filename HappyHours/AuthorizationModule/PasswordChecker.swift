//
//  PasswordChecker.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 17/4/24.
//

import UIKit

protocol PasswordChecker { }

extension PasswordChecker {
    
    func isValidPassword(_ password: String) -> Bool {
        password.count > 7 && password.count < 256
    }
    
}
