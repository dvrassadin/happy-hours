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
        accessToken = keyChainService.getToken(.access)
        refreshToken = keyChainService.getToken(.refresh)
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
    
    // MARK: Profile requests
    
    // MARK: Main requests
    
}
