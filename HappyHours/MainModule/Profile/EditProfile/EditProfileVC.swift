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
    private var newAvatar: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.editProfileView.userImageView.image = self.newAvatar
            }
            avatarWasChanged = true
        }
    }
    private var avatarWasChanged = false

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
        Task {
            do {
                let user = try await model.user
                editProfileView.set(user: user)
                let avatarImage = await model.getAvatarImage()
                editProfileView.set(avatar: avatarImage)
            } catch AuthError.invalidToken {
                logOutWithAlert()
            } catch {
                showAlert(.getUserServerError)
            }
        }
        setUpNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        editProfileView.endEditing(true)
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
    
    // MARK: Update user
    
    private func updateUser() {
        guard isValidCredentials(), let name = editProfileView.nameTextField.text else { return }
        
        editProfileView.isUpdating = true
        Task {
            defer {
                editProfileView.isUpdating = false
            }
            do {
                if avatarWasChanged, let newAvatar {
                    let compressedAvatar = compress(image: newAvatar, toMB: 3)
                    try await model.editUser(
                        imageData: compressedAvatar,
                        name: name,
                        dateOfBirth: editProfileView.datePicker.date
                    )
                } else {
                    try await model.editUser(
                        imageData: nil,
                        name: name,
                        dateOfBirth: editProfileView.datePicker.date
                    )
                }
                navigationController?.popViewController(animated: true)
            } catch AuthError.invalidToken {
                logOutWithAlert()
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
        
        return true
    }
    
    private func compress(image: UIImage, toMB expectedSize: Int) -> Data? {
            let sizeInBytes = expectedSize * 1024 * 1024
            var needCompress: Bool = true
            var imageData: Data?
            var compressingValue: CGFloat = 1.0
            while (needCompress && compressingValue > 0.0) {
                if let data: Data = image.jpegData(compressionQuality: compressingValue) {
                    if data.count < sizeInBytes {
                        needCompress = false
                        imageData = data
                    } else {
                        compressingValue -= 0.1
                    }
                }
            }

            if let imageData {
                if (imageData.count < sizeInBytes) {
                    return imageData
                }
            }
            return nil
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
            
            self.newAvatar = image
        }
    }
    
}
