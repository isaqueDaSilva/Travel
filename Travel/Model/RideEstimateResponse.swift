//
//  RideEstimateResponse.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of the response body with all informations for an estimate ride.
struct RideEstimateResponse: Sendable, Decodable {
    /// The initial point of the ride.
    let origin: Location
    
    /// The end point of the ride.
    let destination: Location
    
    /// The total distance of the ride.
    let distance: Int
    
    /// The total estimated amout of time that the ride will take to be completed.
    let duration: Int
    
    /// All drivers options available to execute this ride.
    let options: [Driver]
}

extension RideEstimateResponse {
    /// Representation of some location in the world by latitude and longitude values.
    struct Location: Sendable, Decodable {
        let latitude: Double
        let longitude: Double
    }
}

extension RideEstimateResponse {
    /// Representation of all available driver information.
    struct Driver: Sendable, Decodable {
        /// The unique identifier of a driver.
        let id: Int
        
        /// The name of the driver.
        let name: String
        
        /// Description message of the driver to customers.
        let description: String
        
        /// Description of what vehicle the driver is utilizing.
        let vehicle: String
        
        /// Review of some user describing what his think about the trip with this driver.
        let review: Review
        
        /// Total cost of this ride.
        let value: Double
    }
}

extension RideEstimateResponse.Driver {
    /// Representation of the driver's review.
    struct Review: Sendable, Decodable {
        let rating: Int
        let comment: String
    }
}
