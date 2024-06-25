//
//  APIError.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 2/5/24.
//

import Foundation

enum APIError: Error {
    
    case invalidServerURL
    case invalidAPIEndpoint
    case notHTTPResponse
    case unexpectedStatusCode
    case encodingError
    case decodingError
    case noToken
    case noActiveSubscription
    case incorrectOTC
    case otcExpired
    case incorrectCredentials
    case accountBlocked
    case userDoesNotExist
    case placeOrderNoHH
    case placeOrderMoreThenOnePerHour
    case placeOrderWasInThisPlace
    case registerEmailTaken
    case registerName
    case registerImage
    case editUserPhotoFormat
    case editUserName
    case notMatchPasswords
    
}
