//
//  MenuVC.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

// MARK: - MenuVC class

final class MenuVC: UIViewController {

    // MARK: Properties
    
    private lazy var menuView = MenuView()
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = menuView
    }

}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    ResetPasswordVC(model: AuthorizationModel(networkService: NetworkService()))
}
