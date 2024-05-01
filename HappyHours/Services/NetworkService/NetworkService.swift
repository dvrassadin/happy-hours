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
//            keyChainService.saveAccessToken(token)
            keyChainService.save(token: token, type: .access)
        }
    }
    private var refreshToken: String? {
        didSet {
            guard let token = accessToken else { return }
//            keyChainService.saveRefreshToken(token)
            keyChainService.save(token: token, type: .refresh)
        }
    }
    
    // MARK: Lifecycle
    
    init() {
//        accessToken = keyChainService.getAccessToken()
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
//        refreshToken = keyChainService.getRefreshToken()
        refreshToken = keyChainService.getToken(.refresh)
    }
    
    // MARK: Authentication requests
    
    func login(_ tokenObtain: Components.Schemas.TokenObtain) async throws {
        let tokenRefresh = try await client.v1_user_token_create(
            body: .json(tokenObtain)
        ).ok.body.json
        logger.info("Login request completed.")
        
        accessToken = tokenRefresh.access
//        print(tokenRefresh.access)
//        keyChainService.saveAccessToken(tokenRefresh.access)
        refreshToken = tokenRefresh.refresh
//        print(tokenRefresh.refresh)
//        keyChainService.saveRefreshToken(tokenRefresh.refresh)
        
//        return tokenRefresh
    }
    
    private func refreshTokens() {
        guard let refreshToken else {
            logOutUser()
            return
        }
        Task {
            do {
                self.refreshToken = try await client.v1_user_token_refresh_create(
                    body: .json(.init(refresh: refreshToken))
                ).ok.body.json.refresh
            } catch {
                logOutUser()
            }
        }
    }
    
    private func logOutUser() {
//        UIApplication.shared.sendAction(
//            #selector(LogInDelegate.logIn),
//            to: nil,
//            from: self,
//            for: nil
//        )
    }

}
