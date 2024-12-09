//
//  RequestService.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

extension RequestRideView {
    /// Defines a Service type to process and send to the server a ride request made by user.
    enum RequestService: Service {
        typealias Response = RideEstimateResponse
        
        /// Processes the ride's request by user.
        static func makeRequest(
            with urlSession: URLSession,
            encodedData: Data
        ) async throws(ExecutionError) -> RideEstimateResponse {
            guard let url = Endpoint.estimate.url else {
                throw .badURL
            }
            
            var request = URLRequest(url: url)
            request.setHTTPMethod(.post)
            
            guard let (responseData, response) = try? await urlSession.upload(for: request, from: encodedData) else {
                throw .executionError
            }
            
            guard let response = response as? HTTPURLResponse else {
                throw .unknownError
            }
            
            switch response.statusCode {
            case 200:
                let estimatedRide = try DecodeData.decode(responseData, for: RideEstimateResponse.self)
                
                return estimatedRide
            case 400:
                let serverError = try DecodeData.decode(responseData, for: ExecutionError.self)
                
                throw serverError
            default:
                throw .badResponse
            }
        }
    }
}
