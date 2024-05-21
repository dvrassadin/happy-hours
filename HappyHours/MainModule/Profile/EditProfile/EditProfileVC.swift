//
//  EditProfileViewController.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import PhotosUI

// MARK: - EditProfileVC class

final class EditProfileVC: UIViewController, NameChecker, EmailChecker, AlertPresenter {
    
    // MARK: Properties
    
    private lazy var editProfileView = EditProfileView()
    private let model: ProfileModelProtocol
    private var avatar: UIImage?

    // MARK: Lifecycle
    
    init(model: ProfileModelProtocol, avatar: UIImage?) {
        self.model = model
        self.avatar = avatar
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
            editProfileView.set(user: user, avatar: avatar)
        }
        setUpNavigation()
    }
    
    // MARK: Navigation
    
    private func setUpNavigation() {
        editProfileView.editImageButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }

            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        }, for: .touchUpInside)
        
        editProfileView.updateButton.addAction(UIAction { [weak self] _ in
            self?.updateUser()
        }, for: .touchUpInside)
    }
    
    private func updateUser() {
        guard isValidCredentials(), let name = editProfileView.nameTextField.text else { return }

        Task {
            do {
                try await model.editUser(
                    imageData: avatar?.pngData(),
                    name: name,
                    dateOfBirth: editProfileView.datePicker.date
                )
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(.editUserServerError)
            }
        }
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

// MARK: - PHPickerViewControllerDelegate

extension EditProfileVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            if let _ = error {
                self.showAlert(.getPhotoError)
            }
            guard let image = reading as? UIImage else { return }
            DispatchQueue.main.async {
                self.editProfileView.userImageView.image = image
                self.avatar = image
            }
        }
    }
    
}
