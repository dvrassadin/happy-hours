//
//  MenuModel.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 7/5/24.
//

import UIKit

final class MenuModel: MenuModelProtocol {
    
    // MARK: Properties
    
    let networkService: NetworkServiceProtocol
    private(set) var restaurant: Restaurant
    private(set) var menu: [(category: String, beverages: [Beverage])] = []
    private var _logoImage: UIImage?
    var logoImage: UIImage? {
        get async {
            if let logoImage = _logoImage {
                return logoImage
            } else if let logoImageString = restaurant.logo,
                      let logoImageData = await networkService.getImageData(from: logoImageString),
                      let logoImage = UIImage(data: logoImageData) {
                return logoImage
            }
            return nil
        }
    }
    private(set) var feedback: [Feedback] = []
    private(set) var countOfAllFeedbacks: Int
    private(set) var answers: [FeedbackAnswer] = []
    private var countOfAllAnswers = 0
    
    // MARK: lifecycle
    
    init(restaurant: Restaurant, logoImage: UIImage?, networkService: NetworkServiceProtocol) {
        self.restaurant = restaurant
        _logoImage = logoImage
        self.networkService = networkService
        countOfAllFeedbacks = restaurant.feedbackCount
    }
    
    // MARK: Get menu
    
    func updateMenu(restaurantID: Int, limit: UInt, offset: UInt) async throws {
        let beverages = try await networkService.getMenu(
            restaurantID: restaurantID,
            limit: limit,
            offset: offset,
            allowRetry: true
        )
        menu = Dictionary(grouping: beverages) { $0.category }
            .map { (category: $0, beverages: $1) }
            .sorted { $0.category < $1.category }
    }
    
    // MARK: Make order
    
    func makeOrder(_ order: PlaceOrder) async throws {
        try await networkService.makeOrder(order, allowRetry: true)
    }
    
    // MARK: Feedback
    
    func updateFeedback(append: Bool = false) async throws {
        if append && feedback.count >= countOfAllFeedbacks { return }
        
        let limit: UInt = 50
        
        if append {
            let feedbacksResponse = try await networkService.getFeedbacks(
                restaurantID: restaurant.id,
                limit: limit,
                offset: UInt(feedback.count),
                allowRetry: true
            )
            feedback.append(contentsOf: feedbacksResponse.results)
        } else {
            let feedbacksResponse = try await networkService.getFeedbacks(
                restaurantID: restaurant.id,
                limit: limit,
                offset: 0,
                allowRetry: true
            )
            feedback = feedbacksResponse.results
            countOfAllFeedbacks = feedbacksResponse.count
        }
    }
    
    func updateFeedbackAnswers(feedbackID: Int, append: Bool = false) async throws {
        if append && answers.count >= countOfAllAnswers { return }
        
        let limit: UInt = 50
        
        if append {
            let answersResponse = try await networkService.getFeedbackAnswers(
                feedbackID: feedbackID,
                limit: limit,
                offset: UInt(answers.count),
                allowRetry: true
            )
            answers.append(contentsOf: answersResponse.results)
        } else {
            let answersResponse = try await networkService.getFeedbackAnswers(
                feedbackID: feedbackID,
                limit: limit,
                offset: 0,
                allowRetry: true
            )
            answers = answersResponse.results
            countOfAllAnswers = answersResponse.count
        }
    }
    
    func sendFeedback(_ text: String) async throws {
        let feedback = SendFeedback(establishment: restaurant.id, text: text)
        try await networkService.sendFeedback(feedback)
    }
    
    func resetFeedbackAnswers() {
        answers = []
        countOfAllAnswers = 0
    }
    
}
