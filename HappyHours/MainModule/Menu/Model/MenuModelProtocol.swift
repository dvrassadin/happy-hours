//
//  MenuModelProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

protocol MenuModelProtocol {
    
    var restaurant: Restaurant { get }
    var menu: [(category: String, beverages: [Beverage])] { get }
    var feedback: [Feedback] { get }
    var countOfAllFeedbacks: Int { get }
    var answers: [FeedbackAnswer] { get }
    var logoImage: UIImage? { get async }
    
    func updateMenu(restaurantID: Int, limit: UInt, offset: UInt) async throws
    func makeOrder(_ order: PlaceOrder) async throws
    func updateFeedback(append: Bool) async throws
    func updateFeedbackAnswers(feedbackID: Int, append: Bool) async throws
    func sendFeedback(_ text: String) async throws
    func sendFeedbackAnswer(feedbackID: Int, text: String) async throws
    func resetFeedbackAnswers()
    
}
