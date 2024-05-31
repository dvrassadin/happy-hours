//
//  FeedbackResponse.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 28/5/24.
//

import Foundation

struct FeedbackResponse: Decodable {
    
    let count: Int
    let results: [Feedback]
}

struct Feedback: Decodable {
    
    let id: Int
    let displayUser: String
    let createdAt: Date
    let text: String
    let answers: Bool
    
}
