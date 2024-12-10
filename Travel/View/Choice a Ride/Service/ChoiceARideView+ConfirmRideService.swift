//
//  ChoiceARideView+ConfirmRideService.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation

extension ChoiceARideView {
    enum ConfirmRideService: Service {
        typealias Response = RideConfirmationResponse
        
        static func makeRequest(with urlSession: URLSession, encodedData: Data) async throws(ExecutionError) -> RideConfirmationResponse {
            guard let url = Endpoint.confirm.url else {
                throw .badURL
            }
            
            var request = URLRequest(url: url)
            request.setHTTPMethod(.patch)
            
            guard let (responseData, response) = try? await urlSession.upload(for: request, from: encodedData) else {
                throw .executionError
            }
            
            guard let response = response as? HTTPURLResponse else {
                throw .unknownError
            }
            
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
