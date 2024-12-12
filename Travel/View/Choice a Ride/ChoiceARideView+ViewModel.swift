//
//  ChoiceARideView+ViewModel.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation
import Observation

extension ChoiceARideView {
    @Observable
    @MainActor
    final class ViewModel {
        var chosenDriver: DriverInformation? = nil
        var chosenRideValue: Double? = nil
        var isProcessing = false
        var isSuccessed = false
        var error: ExecutionError? = nil
        
        var isDisabledButton: Bool {
           (chosenDriver == nil) || isProcessing
        }
        
        func isValidDistance(for driverID: Int, distance: Int) -> Bool {
            switch driverID {
            case 1:
                distance >= 1
            case 2:
                distance >= 5
            case 3:
                distance >= 10
            default:
                false
            }
        }
        
        func isDisabledDriverRow(driverID: Int) -> Bool {
            ((chosenDriver != nil) && (chosenDriver?.id != driverID)) || isProcessing
        }
        
        func confirmRide(
            with urlSession: URLSession = .shared,
            customerID: String,
            origin: String,
            destination: String,
            distance: Int,
            duration: String,
            completation: @escaping () -> Void = { }
        ) {
            isProcessing = true
            
            Task {
                do {
                    let requestBody = RideConfirmationRequest(
                        customerID: customerID,
                        origin: origin,
                        destination: destination,
                        distance: distance,
                        duration: duration,
                        driver: chosenDriver!,
                        value: chosenRideValue!
                    )
                    
                    let data = try EncodeData.encode(data: requestBody)
                    
                    let confirmationStatus = try await ConfirmRideService.makeRequest(
                        with: urlSession,
                        encodedData: data
                    )
                    
                    await MainActor.run {
                        self.isSuccessed = confirmationStatus.isSuccessed
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
