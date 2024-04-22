//
//  ProfileVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 18/4/24.
//

import UIKit

// MARK: - ProfileVC class

final class ProfileVC: UIViewController {

    // MARK: Properties
    
    private let profileView = ProfileView()

    // MARK: Lifecycle
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.setUpUser()
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    ProfileVC()
}
