//
//  FeedbackAnswersResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/5/24.
//

import Foundation

struct FeedbackAnswersResponse: Decodable {
    
    let count: Int
    let results: [FeedbackAnswer]
    
}

struct FeedbackAnswer: Decodable {
    
    let id: Int
    let displayUser: String
    let createdAt: Date
    let text: String
    
}
