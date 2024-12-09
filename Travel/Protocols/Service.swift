//
//  Service.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

/// Defines a set of methods that is required to create a Service type.
protocol Service: Sendable {
    associatedtype Response: Sendable, Decodable
    
    static func makeRequest(with urlSession: URLSession, encodedData: Data) async throws(ExecutionError) -> Response
}
