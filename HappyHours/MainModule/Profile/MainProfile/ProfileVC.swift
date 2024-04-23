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
    private let model: ProfileModelProtocol

    // MARK: Lifecycle
    
    init(model: ProfileModelProtocol) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigation()
        profileView.setUpUser(user: model.user)
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        profileView.logOutButton.addAction(UIAction { [weak self] _ in
            self?.logOut()
        }, for: .touchUpInside)
    }
    
    private func logOut() {
        let alertController = UIAlertController(
            title: String(localized: "Log Out"),
            message: String(localized: "Are you sure you want to logout?"),
            preferredStyle: .actionSheet
        )
        let logOutAction = UIAlertAction(
            title: String(localized: "Log Out"),
            style: .destructive
        ) { _ in
            UIApplication.shared.sendAction(#selector(LogOutDelegate.logOut),
                to: nil,
                from: self,
                for: nil
            )
        }
        alertController.addAction(logOutAction)
        alertController.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel))
        
        present(alertController, animated: true)
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    ProfileVC(model: ProfileModel())
}
