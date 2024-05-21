//
//  NetworkServiceProtocol.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func logIn(_ logIn: LogIn) async throws
    func createUser(_ user: CreateUser) async throws
    func logOut() async throws
    func getRestaurants(
        limit: UInt,
        offset: UInt,
        search: String?,
        allowRetry: Bool
    ) async throws -> [Restaurant]
    func getImageData(from stringURL: String) async -> Data?
    func getUser(allowRetry: Bool) async throws -> User
//    func editUser(_ user: UserUpdate, allowRetry: Bool) async throws
    func editUser(
        imageData: Data?,
        name: String?,
        dateOfBirth: Date?,
        allowRetry: Bool
    ) async throws
    func sendEmailForOTC(_ email: ResetPassword) async throws
    func sendOTC(_ otc: OTC) async throws
    func setNewPassword(_ password: NewPassword, allowRetry: Bool) async throws
    func getMenu(
        restaurantID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool
    ) async throws -> [Beverage]
    func getRestaurants(
        latitude: Double,
        longitude: Double,
        metersRadius: Int,
        allowRetry: Bool
    ) async throws -> [Restaurant]
    func getRestaurant(id: Int, allowRetry: Bool) async throws -> Restaurant
    func getBeverages(
        limit: UInt,
        offset: UInt,
        search: String?,
        allowRetry: Bool
    ) async throws -> BeverageResponse
    func makeOrder(_ order: Order, allowRetry: Bool) async throws
    
}
