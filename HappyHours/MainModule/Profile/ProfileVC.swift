//
//  ProfileVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

final class ProfileVC: UIViewController {

    // MARK: Properties
    
    private let profileView = ProfileView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = profileView
    }

}
