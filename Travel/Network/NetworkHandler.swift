//
//  NetworkHandler.swift
//  Travel
//
//  Created by Isaque da Silva on 12/12/24.
//

import Foundation

/// A default Network handler for API calls.
enum NetworkHandler {
    static func makeRequest(
        endpoint: Endpoint,
        httpMethod: HTTPMethod,
        urlSessionType: URLSessionType,
        urlSession: URLSession
    ) async throws(ExecutionError) -> (Data, HTTPURLResponse) {
        let url = endpoint.url
        
        guard let url else {
            throw .badURL
        }
        
        var request = URLRequest(url: url)
        request.setHTTPMethod(httpMethod)
        
        guard let (responseData, response) = try? await urlSessionType.makeRequest(with: urlSession, and: request) else {
            throw .executionError
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw .badResponse
        }
        
        return (responseData, response)
    }
    
    enum URLSessionType {
        case upload(Data)
        case getData
        
        func makeRequest(
            with session: URLSession,
            and request: URLRequest
        ) async throws -> (Data, URLResponse) {
            switch self {
            case .upload(let data):
                try await session.upload(for: request, from: data)
            case .getData:
                try await session.data(for: request)
            }
        }
    }
}
