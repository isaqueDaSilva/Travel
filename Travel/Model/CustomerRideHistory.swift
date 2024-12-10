//
//  CustomerRideHistory.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of the ride's history made by a customer.
struct CustomerRideHistory: Sendable, Decodable {
    /// Customer's unique identifier.
    let customerID: String
    
    /// List of all rides made by the customer.
    let rides: [Ride]
}

extension CustomerRideHistory {
    /// Representation of a single ride made by a user.
    struct Ride: Sendable, Decodable {
        /// Ride's unique identifier.
        let id: Int
        
        /// Date when this ride was made.
        let date: Date
        
        /// Start point of this ride.
        let origin: String
        
        /// End point of this ride.
        let destination: String
        
        /// Total distance of this ride.
        let distance: Double
        
        /// Total duration of this ride.
        let duration: String
        
        /// Information of the driver that's made this ride.
        let driver: DriverInformation
        
        /// Total cust of this ride.
        let value: Double
    }
}
