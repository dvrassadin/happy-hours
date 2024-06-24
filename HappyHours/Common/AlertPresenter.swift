//
//  AlertPresenter.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 23/4/24.
//

import UIKit

// MARK: - AlertPresenter protocol

protocol AlertPresenter: UIViewController { }

// MARK: - Alert cases

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
    case getPhotoError
    case invalidToken
    case getFeedbackServerError
    case sendFeedbackServerError
    case getFeedbackAnswersServerError
    case noSubscriptionForScanning
    case getSubscriptionServerError
    case sendFeedbackAnswerServerError
    case getSubscriptionPlansServerError
    case createPaymentError
    case paymentError
    case createFreeTrialServerError
    case executePaymentSessionExpired
    case executePaymentUnknownError
}

// MARK: Alert presenting

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
            message = String(localized: "Failed to get list of establishments. Try again.")
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
            message = String(localized: "There are no beverages available at this establishment.")
        case .makingOrderServerError:
            title = String(localized: "Unable to Make Order")
            message = String(localized: "Failed to make the order. It may not be happy hours or you may have ordered recently.")
        case .orderMade:
            title = String(localized: "Order Placed")
            message = String(localized: "Your order was successful. Enjoy your meal.")
        case .invalidBarcode:
            title = String(localized: "Incorrect Barcode")
            message = String(localized: "This is not an establishment menu barcode.")
        case .barcodeServerError:
            title = String(localized: "Error Getting Establishment")
            message = String(localized: "This establishment was not found or there are problems with the Internet.")
        case .getRestaurantServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get the establishment.")
        case .restaurantsNotFound:
            title = String(localized: "Nothing Found")
            message = String(localized: "Could not find such establishment.")
        case .beveragesServerError:
            title = String(localized: "Error")
            message = String(localized: "An error occurred while searching for drinks.")
        case .getPhotoError:
            title = String(localized: "Unable to Get Image")
        case .invalidToken:
            title = String(localized: "Session Expired")
            message = String(localized: "You need to log into the application again.")
        case .getFeedbackServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get the feedback.")
        case .sendFeedbackServerError:
            title = String(localized: "Unable to Send")
            message = String(localized: "Failed to send the feedback.")
        case .getFeedbackAnswersServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get the feedback answers.")
        case .noSubscriptionForScanning:
            title = String(localized: "No Subscription")
            message = String(localized: "You must have a subscription to scan codes.")
        case .getSubscriptionServerError:
            title = String(localized: "Unable to Get Subscription")
            message = String(localized: "Failed to get subscription status. You must have a subscription to scan codes.")
        case .sendFeedbackAnswerServerError:
            title = String(localized: "Unable to Send")
            message = String(localized: "Failed to send your reply to this review.")
        case .getSubscriptionPlansServerError:
            title = String(localized: "Unable to Download")
            message = String(localized: "Failed to get subscription pans.")
        case .createPaymentError:
            title = String(localized: "Unable to Make Payment")
            message = String(localized: "You already have an active subscription.")
        case .paymentError:
            title = String(localized: "Error")
            message = String(localized: "Failed to make payment.")
        case .createFreeTrialServerError:
            title = String(localized: "Error")
            message = String(localized: "Failed to get Fee Trial.")
        case .executePaymentSessionExpired:
            title = String(localized: "Unable to Make Payment")
            message = String(localized: "Session has expired. Try again.")
        case .executePaymentUnknownError:
            title = String(localized: "Unable to Make Payment")
            message = String(localized: "Unknown error. Try again.")
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

// MARK: Log out

extension AlertPresenter {
    
    func logOutWithAlert() {
        showAlert(.invalidToken) { _ in
            UIApplication.shared.sendAction(
                #selector(LogOutDelegate.logOut),
                to: nil,
                from: self,
                for: nil
            )
        }
    }
    
}
