//
//  NetworkService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import OSLog

final class NetworkService: NetworkServiceProtocol, AuthServiceDelegate {
    
    // MARK: Properties
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.configuration.timeoutIntervalForRequest = 20
        return session
    }()
    
    private let customDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    private let isoDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        return dateFormatter
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let baseURL = "https://happyhours.zapto.org"
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: NetworkService.self)
    )
    
    private let authService: AuthServiceProtocol
    
    // MARK: Lifecycle
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        Task {
            await authService.set(delegate: self)
        }
    }
    
    // MARK: Authentication requests
    
    func logIn(_ logIn: LogIn) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/client/auth/token/")
        
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

        await authService.set(tokens: tokens)
    }
    
    func createUser(_ user: CreateUser) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/client/register/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            encoder.dateEncodingStrategy = .formatted(customDateFormatter)
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
        
        await authService.set(tokens: tokens)
    }
    
    func refreshTokens(refreshToken: String) async throws -> Tokens {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/auth/token/refresh/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let refresh = RefreshToken(refresh: refreshToken)
        
        do {
            request.httpBody = try encoder.encode(refresh)
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
        
        if httpResponse.statusCode == 401 {
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)\n\(String(data: data, encoding: .utf8) ?? "")")
            throw APIError.unexpectedStatusCode
        }
        
        let tokens: Tokens
        do {
            tokens = try decoder.decode(Tokens.self, from: data)
            logger.info("Received tokens for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return tokens
    }
    
    func logOut() async throws {
        await authService.deleteTokens()
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/auth/logout/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let logOut = RefreshToken(refresh: try await authService.validRefreshToken)
        
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
        
        urlComponents.path.append("/api/v1/user/client/password/forgot/")
        
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
        
        urlComponents.path.append("/api/v1/user/client/password/reset/")
        
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

        await authService.set(tokens: tokens)
    }
    
    func setNewPassword(_ newPassword: NewPassword, allowRetry: Bool = true) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/client/password/change/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        request.httpBody = try encoder.encode(newPassword)
        
        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await setNewPassword(newPassword, allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("Completed set new password request: \(url.absoluteString)")
    }
    
    // MARK: Profile requests
    
    func getUser(allowRetry: Bool = true) async throws -> User {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/users/profile/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await  getUser(allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let user: User
        do {
            decoder.dateDecodingStrategy = .formatted(customDateFormatter)
            user = try decoder.decode(User.self, from: data)
            logger.info("Received user for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }

        return user
    }
    
    func editUser(
        imageData: Data?,
        name: String?,
        dateOfBirth: Date?,
        allowRetry: Bool = true
    ) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/user/users/profile/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        let lineBreak = "\r\n"
        
        request.addValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        guard let boundaryPrefix = "--\(boundary + lineBreak)".data(using: .utf8) else {
            logger.error("Could not encode data for request: \(request)")
            throw APIError.encodingError
        }
        
        var body = Data()
        
        if let imageData {
            guard let contentDescription = "Content-Disposition: form-data; name=\"avatar\"; filename=\"\(Date().formatted()).jpg\"\(lineBreak)".data(using: .utf8),
                  let contentType = "Content-Type: image/png\(lineBreak)\(lineBreak)".data(using: .utf8),
                  let lineBreak = lineBreak.data(using: .utf8) else {
                logger.error("Could not encode data for request: \(request)")
                throw APIError.encodingError
            }
            body.append(boundaryPrefix)
            body.append(contentDescription)
            body.append(contentType)
            body.append(imageData)
            body.append(lineBreak)
        }
        
        if let name {
            guard let contentDescription = "Content-Disposition: form-data; name=\"name\"\(lineBreak)\(lineBreak)".data(using: .utf8),
                  let content = "\(name)\(lineBreak)".data(using: .utf8) else {
                logger.error("Could not encode data for request: \(request)")
                throw APIError.encodingError
            }
            body.append(boundaryPrefix)
            body.append(contentDescription)
            body.append(content)
        }
        
        if let dateOfBirth {
            guard let contentDescription = "Content-Disposition: form-data; name=\"date_of_birth\"\(lineBreak)\(lineBreak)".data(using: .utf8),
                  let content = "\(customDateFormatter.string(from: dateOfBirth))".data(using: .utf8)
            else {
                logger.error("Could not encode data for request: \(request)")
                throw APIError.encodingError
            }
            body.append(boundaryPrefix)
            body.append(contentDescription)
            body.append(content)
        }
        
        request.httpBody = body
        
        logger.info("Starting request: \(url.absoluteString)")
        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                try await editUser(
                    imageData: imageData,
                    name: name,
                    dateOfBirth: dateOfBirth,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        logger.info("User edited for request: \(url.absoluteString)")
    }
    
    // MARK: Establishments requests
    
    func getRestaurants(
        limit: UInt,
        offset: UInt,
        search: String? = nil,
        allowRetry: Bool = true
    ) async throws -> [Restaurant] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/partner/establishments/")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        if let search {
            urlComponents.queryItems?.append(URLQueryItem(name: "search", value: search))
        }
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getRestaurants(
                    limit: limit,
                    offset: offset,
                    search: search,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let restaurants: [Restaurant]
        do {
            restaurants = try decoder.decode(RestaurantsResponse.self, from: data).results
            logger.info("Received restaurants for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return restaurants
    }
    
    func getRestaurants(
        latitude: Double,
        longitude: Double,
        metersRadius: Int,
        allowRetry: Bool = true
    ) async throws -> [Restaurant] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/partner/establishments/")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "near_me", value: String(metersRadius)),
        ]
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getRestaurants(
                    latitude: latitude,
                    longitude: longitude,
                    metersRadius: metersRadius,
                    allowRetry: true
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let restaurants: [Restaurant]
        do {
            restaurants = try decoder.decode([Restaurant].self, from: data)
            logger.info("Received restaurants for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return restaurants
    }
    
    func getRestaurant(id: Int, allowRetry: Bool = true) async throws -> Restaurant {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/partner/establishments/\(id)/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getRestaurant(id: id, allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let restaurant: Restaurant
        do {
            restaurant = try decoder.decode(Restaurant.self, from: data)
            logger.info("Received restaurant for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return restaurant
    }
    
    // MARK: Menus and orders requests
    
    func getMenu(
        restaurantID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool = true
    ) async throws -> [Beverage] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/partner/menu/\(restaurantID)/")
        
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
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getMenu(
                    restaurantID: restaurantID,
                    limit: limit,
                    offset: offset,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let menu: [Beverage]
        do {
            menu = try decoder.decode(BeverageResponse.self, from: data).results
            logger.info("Received menu for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }

        return menu
    }
    
    func makeOrder(_ order: PlaceOrder, allowRetry: Bool = true) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/order/place-order/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            request.httpBody = try encoder.encode(order)
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
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await makeOrder(order, allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 201 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("Order was made for request: \(url.absoluteString)")
    }
    
    func getOrders(
        limit: UInt,
        offset: UInt,
        allowRetry: Bool = true
    ) async throws -> OrdersResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/order/client-order-history/")
        
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
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getOrders(limit: limit, offset: offset, allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
        let ordersResponse: OrdersResponse
        do {
            ordersResponse = try decoder.decode(OrdersResponse.self, from: data)
            logger.info("Received menu for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }

        return ordersResponse
    }
    
    // MARK: Beverages requests
    
    func getBeverages(
        limit: UInt,
        offset: UInt,
        search: String? = nil,
        allowRetry: Bool = true
    ) async throws -> BeverageResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/beverage/beverages/")
        
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        if let search {
            urlComponents.queryItems?.append(URLQueryItem(name: "search", value: search))
        }
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getBeverages(
                    limit: limit,
                    offset: offset,
                    search: search,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let beverageResponse: BeverageResponse
        do {
            beverageResponse = try decoder.decode(BeverageResponse.self, from: data)
            logger.info("Received beverages for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return beverageResponse
    }
    
    // MARK: Common requests
    
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
    
    // MARK: Feedbacks
    
    func getFeedbacks(
        restaurantID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool = true
    ) async throws -> FeedbackResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/feedback/feedbacks/list/\(restaurantID)/")
        
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
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getFeedbacks(
                    restaurantID: restaurantID,
                    limit: limit,
                    offset: offset,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let feedbacks: FeedbackResponse
        do {
            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
            feedbacks = try decoder.decode(FeedbackResponse.self, from: data)
            logger.info("Received feedback for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return feedbacks
    }
    
    func getFeedbackAnswers(
        feedbackID: Int,
        limit: UInt,
        offset: UInt,
        allowRetry: Bool = true
    ) async throws -> FeedbackAnswersResponse {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/feedback/feedbacks/\(feedbackID)/answers/list/")
        
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
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getFeedbackAnswers(
                    feedbackID: feedbackID,
                    limit: limit,
                    offset: offset,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let answersResponse: FeedbackAnswersResponse
        do {
            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
            answersResponse = try decoder.decode(FeedbackAnswersResponse.self, from: data)
            logger.info("Received answers for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return answersResponse
    }
    
    func sendFeedback(_ feedback: SendFeedback) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/feedback/feedbacks/create/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            request.httpBody = try encoder.encode(feedback)
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

        guard httpResponse.statusCode == 201 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        logger.info("Feedback sent for request: \(url.absoluteString)")
    }
    
    func sendFeedbackAnswer(_ feedbackAnswer: FeedbackAnswerCreate) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/feedback/answers/create/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            request.httpBody = try encoder.encode(feedbackAnswer)
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

        guard httpResponse.statusCode == 201 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        logger.info("Feedback answer sent for request: \(url.absoluteString)")
    }
    
    // MARK: Subscription
    
    func getActiveSubscription(allowRetry: Bool) async throws -> Subscription {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/subscription/subscriptions/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getActiveSubscription(allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        if httpResponse.statusCode == 404 {
            logger.error("There are not an active subscription for request: \(url.absoluteString)")
            throw APIError.noActiveSubscription
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let subscription: Subscription
        do {
            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
            subscription = try decoder.decode(Subscription.self, from: data)
            logger.info("Received subscription for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return subscription
    }
    
    func getSubscriptionPlans(allowRetry: Bool) async throws -> [SubscriptionPlan] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/subscription/subscription-plans/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await getSubscriptionPlans(allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let subscriptionPlans: [SubscriptionPlan]
        do {
            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
            subscriptionPlans = try decoder.decode([SubscriptionPlan].self, from: data)
            logger.info("Received subscription for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return subscriptionPlans
    }
    
    func createPayment(subscriptionPlanID: Int, allowRetry: Bool) async throws -> Payment {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/subscription/create-payment/\(subscriptionPlanID)/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        logger.info("Starting request: \(url.absoluteString)")
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("API response is not HTTP response")
            throw APIError.notHTTPResponse
        }
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await createPayment(
                    subscriptionPlanID: subscriptionPlanID,
                    allowRetry: false
                )
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        let payment: Payment
        do {
            payment = try decoder.decode(Payment.self, from: data)
            logger.info("Received payment URL for request: \(url.absoluteString)")
        } catch {
            logger.error("Could not decode data for request: \(url.absoluteString)\n\(error)")
            throw APIError.decodingError
        }
        
        return payment
    }
    
    func createFreeTrial(freeTrial: FreeTrial, allowRetry: Bool) async throws {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.error("Invalid server URL: \(self.baseURL)")
            throw APIError.invalidServerURL
        }
        
        urlComponents.path.append("/api/v1/subscription/free-trial/")
        
        guard let url = urlComponents.url else {
            logger.error("Invalid API endpoint: \(urlComponents)")
            throw APIError.invalidAPIEndpoint
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(
            "Bearer \(try await authService.validAccessToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        do {
            request.httpBody = try encoder.encode(freeTrial)
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
        
        if httpResponse.statusCode == 401 {
            if allowRetry {
                try await authService.refreshTokens()
                return try await createFreeTrial(freeTrial: freeTrial, allowRetry: false)
            }
            logger.error("Invalid token for request: \(url.absoluteString)")
            throw AuthError.invalidToken
        }
        
        guard httpResponse.statusCode == 200 else {
            logger.error("Unexpected status code: \(httpResponse.statusCode)")
            throw APIError.unexpectedStatusCode
        }
        
        logger.info("Free trial activated for request: \(url.absoluteString)")
    }
    
}
