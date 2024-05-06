//
//  EditProfileViewController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

final class EditProfileVC: UIViewController, NameChecker, EmailChecker, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var editProfileView = EditProfileView()
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
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = model.user {
            editProfileView.set(user: user)
        }
        setUpNavigation()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        editProfileView.editImageButton.addAction(UIAction { [weak self] _ in
            self?.editUserImage()
        }, for: .touchUpInside)
        
        editProfileView.updateButton.addAction(UIAction { [weak self] _ in
            self?.updateUser()
        }, for: .touchUpInside)
    }
    
    private func editUserImage() {
        print("Edit user image button pressed.")
    }
    
    private func updateUser() {
        guard isValidCredentials(), let name = editProfileView.nameTextField.text else { return }

        Task {
            do {
                let user = UserUpdate(
                    name: name,
                    dateOfBirth: editProfileView.datePicker.date,
                    avatar: nil
                )
                try await model.editUser(user)
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(.editUserServerError)
            }
        }
//        model.updateUser(
//            User(
//                name: name,
//                email: email,
//                birthday: editProfileView.datePicker.date,
//                avatar: editProfileView.userImageView.image
//            )
//        )
//        navigationController?.popViewController(animated: true)
    }
    
    private func isValidCredentials() -> Bool {
        guard let name = editProfileView.nameTextField.text else {
            showAlert(.emptyName)
            return false
        }
        
        guard isValidName(name) else {
            showAlert(.invalidName)
            return false
        }
        
        guard let email = editProfileView.emailTextField.text, isValidEmail(email) else {
            showAlert(.invalidEmail)
            return false
        }
        
        return true
    }
    
}
