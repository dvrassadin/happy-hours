//
//  NetworkService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import OSLog

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: Properties
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 20
        return session
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    private let baseURL = "http://16.170.203.161"
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: NetworkService.self)
    )
    
    private let keyChainService: TokensKeyChainServiceProtocol = KeyChainService()
    
    private var accessToken: String? {
        didSet {
            guard let token = accessToken else { return }
            keyChainService.save(token: token, type: .access)
        }
    }
    
    private var refreshToken: String? {
        didSet {
            guard let token = accessToken else { return }
            keyChainService.save(token: token, type: .refresh)
        }
    }
    
    // MARK: Lifecycle
    
    init() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            accessToken = keyChainService.getToken(.access)
            refreshToken = keyChainService.getToken(.refresh)
        }
    }
    
    // MARK: Authentication requests
    
    func logIn(_ logIn: LogIn) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/token/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(logIn)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)")
            throw APIError.encodingError
        }
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let tokens: Tokens
        do {
            tokens = try decoder.decode(Tokens.self, from: data)
            logger.info("Received tokens for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)")
            throw APIError.decodingError
        }

        accessToken = tokens.access
        refreshToken = tokens.refresh
    }
    
    func createUser(_ user: CreateUser) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/client_register/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)")
            throw APIError.encodingError
        }
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }

        guard httpResponse.statusCode == 201 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        logger.info("User created for request: \(url.absoluteString)")
        
        let tokens: Tokens
        do {
            tokens = try decoder.decode(CreateUserResponse.self, from: data).tokens
            logger.info("Received tokens for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)")
            throw APIError.decodingError
        }
        
        accessToken = tokens.access
        refreshToken = tokens.refresh
    }
    
    func logOut() async throws {
        guard let refreshToken else {
            logger.error("Refresh token is nil when trying to log out.")
            throw APIError.noToken
        }
        
        accessToken = nil
        self.refreshToken = nil
        keyChainService.deleteAllTokens()
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/logout/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let logOut = LogOut(refresh: refreshToken)
        
        do {
            request.httpBody = try encoder.encode(logOut)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)")
            throw APIError.encodingError
        }
        
        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("User logged out for request: \(url.absoluteString)")
    }
    
    func sendEmailForOTC(_ email: ResetPassword) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/password_forgot/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(email)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.encodingError
        }

        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }

        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("Email sent for request: \(url.absoluteString)")
    }
    
    func sendOTC(_ otc: OTC) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/password_reset/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(otc)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.encodingError
        }

        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }

        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("OTC successfully sent for request: \(url.absoluteString)")
        
        let tokens: Tokens
        do {
            tokens = try decoder.decode(Tokens.self, from: data)
            logger.info("Received tokens for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)")
            throw APIError.decodingError
        }

        accessToken = tokens.access
        refreshToken = tokens.refresh
    }
    
    func setNewPassword(_ newPassword: NewPassword) async throws {
        guard let accessToken else {
            logger.error("Access token is nil when trying to get restaurants.")
            throw APIError.noToken
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/password_change/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = try encoder.encode(newPassword)
        
        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("Completed set new password request: \(url.absoluteString)")
    }
    
    // MARK: Profile requests
    
    func getUser() async throws -> User {
        guard let accessToken else {
            logger.error("Access token is nil when trying to get restaurants.")
            throw APIError.noToken
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let user: User
        do {
            user = try decoder.decode(User.self, from: data)
            logger.info("Received user for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }

        return user
    }
    
    func editUser(_ user: UserUpdate) async throws {
        guard let accessToken else {
            logger.error("Access token is nil when trying to get restaurants.")
            throw APIError.noToken
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try encoder.encode(user)
        } catch {
            logger.error("Could not encode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.encodingError
        }

        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }

        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        logger.info("User edited for request: \(url.absoluteString)")
    }
    
    // MARK: Restaurants requests
    
    func getRestaurants(limit: UInt, offset: UInt) async throws -> [Restaurant] {
        guard let accessToken else {
            logger.error("Access token is nil when trying to get restaurants.")
            throw APIError.noToken
        }
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/partner/establishment/list/")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let restaurants: [Restaurant]
        do {
            restaurants = try decoder.decode(RestaurantsResponse.self, from: data).results.features
            logger.info("Received restaurants for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return restaurants
    }
    
    func getImageData(from stringURL: String) async -> Data? {
        guard let url = URL(string: stringURL) else { return nil }
        
        logger.info("Starting request: \(url.absoluteString)")
        do {
            let (data, _) = try await session.data(from: url)
            return data
        } catch {
            logger.error("Data not received for image request: \(url.absoluteString)")
        }
        
        return nil
    }
    
}
