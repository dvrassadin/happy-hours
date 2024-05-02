//
//  NetworkService.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 29/4/24.
//

import OSLog
import OpenAPIRuntime
import OpenAPIURLSession

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: Properties
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "",
        category: String(describing: NetworkService.self)
    )
    private let server = try! Servers.server1()
    private var client: Client
    private let keyChainService: TokensKeyChainServiceProtocol = KeyChainService()
    private var accessToken: String? {
        didSet {
            guard let token = accessToken else { return }
            client = Client(
                serverURL: server,
                transport: URLSessionTransport(),
                middlewares: [AuthenticationMiddleware(token: token)]
            )
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
        if let accessToken {
            client = Client(
                serverURL: server,
                transport: URLSessionTransport(),
                middlewares: [AuthenticationMiddleware(token: accessToken)]
            )
        } else {
            client = Client(serverURL: server, transport: URLSessionTransport())
        }
        refreshToken = keyChainService.getToken(.refresh)
    }
    
    // MARK: Authentication requests
    
    func login(_ tokenObtain: Components.Schemas.TokenObtain) async throws {
        let tokenRefresh = try await client.v1_user_token_create(
            body: .json(tokenObtain)
        ).ok.body.json
        logger.info("Login request completed.")
        
        accessToken = tokenRefresh.access
        refreshToken = tokenRefresh.refresh
    }
    
//    private func refreshTokens() {
//        guard let refreshToken else { return }
//        Task {
//            do {
//                self.refreshToken = try await client.v1_user_token_refresh_create(
//                    body: .json(.init(refresh: refreshToken))
//                ).ok.body.json.refresh
//            } catch {
//
//            }
//        }
//    }
    
    func createUser(_ user: Components.Schemas.ClientRegister) async throws {
        print(user.email)
        print(user.password)
        print(user.password_confirm)
        print(user.name)
        print(user.date_of_birth)
        let response = try await client.v1_user_client_register_create(
            body: .json(
                .init(
                    email: user.email,
                    password: user.password,
                    password_confirm: user.password_confirm,
                    name: user.name,
                    date_of_birth: user.date_of_birth
                )
            )
        )
        logger.info("Create user request completed.")

        switch response {
        case let .created(okResponse):
            print("created")
            switch okResponse.body {
            case .json(let json):
                accessToken = json.tokens?.access
                refreshToken = json.tokens?.refresh
            }
        case .undocumented(statusCode: let statusCode, _):
            logger.error("Create user response status code: \(statusCode).")
            throw APIError.userWasNotCreated
        }
    }
    
}
