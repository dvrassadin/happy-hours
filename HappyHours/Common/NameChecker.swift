//
//  NameChecker.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 22/4/24.
//

import Foundation

protocol NameChecker { }

extension NameChecker {
    
    func isValidName(_ name: String) -> Bool {
        !name.isEmpty && name.count <= 100 && !name.contains { $0.isNumber }
    }
    
}
