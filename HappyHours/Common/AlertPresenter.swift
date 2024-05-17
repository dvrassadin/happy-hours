//
//  AlertPresenter.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

enum AlertType {
    
    case invalidEmail
    case invalidPasswordLength
    case notMatchPasswords
    case accountCreated
    case emptyName
    case invalidName
    case accessDenied
    case createUserServerError
    case getRestaurantsServerError
    case getUserServerError
    case editUserServerError
    case sendingEmailServerError
    case incorrectOTC
    case settingNewPasswordServerError
    case gettingMenuServerError
    case makingOrderServerError
    case orderMade
    case invalidBarcode
    case barcodeServerError
    case getRestaurantServerError
    case restaurantsNotFound
    case beveragesServerError
    
}

protocol AlertPresenter: UIViewController { }

extension AlertPresenter {
    
    func showAlert(
        _ type: AlertType,
        message: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        var message = message
        let title: String
        
        switch type {
        case .invalidEmail:
            title = String(localized: "Invalid Email")
            message = String(localized: "This email address is not valid.\nEnter a different address.")
        case .invalidPasswordLength:
            title = String(localized: "Invalid Password")
            message = String(localized: "This password is too short.\nPasswords are 8 and more characters long.")
        case .notMatchPasswords:
            title = String(localized: "Passwords do not Match")
            message = String(localized: "Enter your new passwords again.")
        case .emptyName:
            title = String(localized: "Empty Name")
            message = String(localized: "Please, enter your name.")
        case .accountCreated:
            title = String(localized: "Success")
            message = String(localized: "Your account was created.")
        case .invalidName:
            title = String(localized: "Invalid Name")
            message = String(localized: "Name should not be empty and contains digits.")
        case .accessDenied:
            title = String(localized: "Access Denied")
            message = String(localized: "The password is incorrect or the user is not registered.")
        case .createUserServerError:
            title = String(localized: "Cannot Create Account")
        case .getRestaurantsServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get list of restaurants. Try again.")
        case .getUserServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get your credentials.")
        case .editUserServerError:
            title = String(localized: "Unable to Update")
            message = String(localized: "Failed to update your credentials.")
        case .sendingEmailServerError:
            title = String(localized: "Error")
            message = String(localized: "The email could not be sent or the user does not exist.")
        case .incorrectOTC:
            title = String(localized: "Incorrect Code")
            message = String(localized: "The one-time code is incorrect.")
        case .settingNewPasswordServerError:
            title = String(localized: "Unable to Set Password")
            message = String(localized: "The password does not meet the password requirements or the server is unavailable.")
        case .gettingMenuServerError:
            title = String(localized: "Unable to Get Menu")
            message = String(localized: "Failed to get menu. Check your internet connection.")
        case .makingOrderServerError:
            title = String(localized: "Unable to Make Order")
            message = String(localized: "Failed to make the order. It may not be happy hours or you may have ordered recently.")
        case .orderMade:
            title = String(localized: "Order Placed")
            message = String(localized: "Your order was successful. Enjoy your meal.")
        case .invalidBarcode:
            title = String(localized: "Incorrect Barcode")
            message = String(localized: "This is not a restaurant menu barcode.")
        case .barcodeServerError:
            title = String(localized: "Error Getting Restaurant")
            message = String(localized: "This restaurant was not found or there are problems with the Internet.")
        case .getRestaurantServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get the restaurant.")
        case .restaurantsNotFound:
            title = String(localized: "Nothing Found")
            message = String(localized: "Could not find such restaurants.")
        case .beveragesServerError:
            title = String(localized: "Error")
            message = String(localized: "An error occurred while searching for drinks.")
        }
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        
        present(alertController, animated: true)
    }
    
}
