//
//  RequestRideView+ViewModel.swift
//  Travel
//
//  Created by Isaque da Silva on 12/7/24.
//

import Foundation
import Observation

extension RequestRideView {
    @Observable
    @MainActor
    final class ViewModel {
        var customerID = ""
        var initialLocation = ""
        var destination = ""
        var isProcessing = false
        var ride: RideEstimateResponse? = nil
        var error: ExecutionError? = nil
        
        private var isDestinationSameAsInitialLocation: Bool {
            (initialLocation == destination)
        }
        
        private var isSomeFieldEmpty: Bool {
            customerID.isEmpty || initialLocation.isEmpty || destination.isEmpty
        }
        
        var isDisabled: Bool {
            isDestinationSameAsInitialLocation || isSomeFieldEmpty || isProcessing
        }
        
        func makeRideRequest(
            with urlSession: URLSession = .shared,
            completation: @escaping (() -> Void) = { }
        ) {
            isProcessing = true
            
            Task {
                do {
                    let requestBody = RideEstimateRequest(
                        customerID: self.customerID,
                        origin: self.initialLocation,
                        destination: self.destination
                    )
                    
                    let data = try EncodeData.encode(data: requestBody)
                    
                    let ride = try await RequestService.makeRequest(with: urlSession, encodedData: data)
                    
                    await MainActor.run {
                        self.ride = ride
                        self.isProcessing = false
                        completation()
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
