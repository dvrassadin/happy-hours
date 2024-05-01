//
//  AuthenticationMiddleware.swift
//  HappyHours
//
//  Created by Daniil Rassadin on 30/4/24.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

// MARK: - AuthenticationMiddleware struct

struct AuthenticationMiddleware {
    
    // MARK: Properties
    
    let token: String
    
}

// MARK: - ClientMiddleware protocol

extension AuthenticationMiddleware: ClientMiddleware {
    
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(token)"
        return try await next(request, body, baseURL)
    }
    
}
