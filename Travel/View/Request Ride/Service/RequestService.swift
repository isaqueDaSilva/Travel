//
//  RequestService.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

extension RequestRideView {
    enum RequestService {
        static func makeRequest(
            with urlSession: URLSession,
            encodedData: Data
        ) async throws(ExecutionError) -> RideEstimateResponse {
            let (responseData, response) = try await NetworkHandler.makeRequest(
                endpoint: .estimate,
                httpMethod: .post,
                urlSessionType: .upload(encodedData),
                urlSession: urlSession
            )
            
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
