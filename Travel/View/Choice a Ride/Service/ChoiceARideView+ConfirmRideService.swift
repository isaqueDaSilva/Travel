//
//  ChoiceARideView+ConfirmRideService.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation

extension ChoiceARideView {
    enum ConfirmRideService {
        static func makeRequest(with urlSession: URLSession, encodedData: Data) async throws(ExecutionError) -> RideConfirmationResponse {
            let (responseData, response) = try await NetworkHandler.makeRequest(
                endpoint: .confirm,
                httpMethod: .patch,
                urlSessionType: .upload(encodedData),
                urlSession: urlSession
            )
            
            switch response.statusCode {
            case 200:
                let confirmationRide = try DecodeData.decode(responseData, for: RideConfirmationResponse.self)
                
                return confirmationRide
            case 400, 404, 406:
                let serverError = try DecodeData.decode(responseData, for: ExecutionError.self)
                
                throw serverError
            default:
                throw .badResponse
            }
        }
        
    }
}
