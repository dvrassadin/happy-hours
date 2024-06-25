//
//  ErrorBody.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 25/6/24.
//

import Foundation

struct ErrorBody: Decodable {
    
    let errorCode: String
    let message: String
    
}
