//
//  LogInDelegate.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 20/4/24.
//

import Foundation

@objc protocol LogInDelegate {
    
    func logIn()
    
}

//protocol LogInDelegate { }
//
//extension LogInDelegate {
//    
//    var isLoggedIn: Bool {
//        get { UserDefaults.standard.bool(forKey: "isLoggedIn") }
//        set { UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn") }
//    }
//    
//    func logIn() {
//        
//    }
//    
//}
