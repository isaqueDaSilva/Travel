//
//  HistoryView+ViewModel.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import Foundation
import Observation

extension HistoryView {
    @Observable
    @MainActor
    final class ViewModel {
        var customID = ""
        var selectedDriver = 1
        var isProcessing = false
        var rideHistory: CustomerRideHistory? = nil
        var error: ExecutionError? = nil
        
        var isDisabled: Bool {
            customID.isEmpty
        }
        
        func getHistory(
            with urlSession: URLSession = .shared
        ) {
            isProcessing = true
            
            Task {
                do {
                    let (responseData, response) = try await NetworkHandler.makeRequest(
                        endpoint: .history(customID, "\(selectedDriver)"),
                        httpMethod: .get,
                        urlSessionType: .getData,
                        urlSession: urlSession
                    )
                    
                    switch response.statusCode {
                    case 200:
                        let history = try DecodeData.decode(responseData, for: CustomerRideHistory.self)
                        
                        await MainActor.run {
                            rideHistory = history
                            isProcessing = false
                        }
                    case 400, 404:
                        let serverError = try DecodeData.decode(responseData, for: ExecutionError.self)
                        
                        throw serverError
                    default:
                        throw ExecutionError.badResponse
                    }
                } catch let error as ExecutionError {
                    await MainActor.run {
                        self.error = error
                        self.isProcessing = false
                    }
                }
            }
        }
    }
}
