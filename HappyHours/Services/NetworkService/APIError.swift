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
    
}
