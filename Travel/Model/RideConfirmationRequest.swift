//
//  RideConfirmationRequest.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of the confirmation body for a ride.
struct RideConfirmationRequest: Sendable {
    /// Unique identifier of a customer.
    let customerID: String
    
    /// Initial point of the ride.
    let origin: String
    
    /// Final destination of the ride.
    let destination: String
    
    /// Total distance of the ride.
    let distance: Int
    
    /// Total duration of the ride.
    let duration: String
    
    /// Some information of the driver.
    let driver: DriverInformation
    
    /// Total cust of the ride.
    let value: Double
}

// MARK: - Encoding Method -
extension RideConfirmationRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case origin
        case destination
        case distance
        case duration
        case driver
        case value
    }
    
    /// Encodes this struct into a apropriate format with aproprieted keys.
    ///
    /// This struct will be transformed into a same format as the following sample JSON:
    /// ```JSON
    ///{
    ///     "customer_id": "CT01",
    ///     "origin": "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
    ///     "destination": "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
    ///     "distance": 20018,
    ///     "duration": "1920",
    ///     "driver": {
    ///         "id": 1,
    ///         "name": "Homer Simpson"
    ///     },
    ///     "value": 50.05
    ///}
    /// ```
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.customerID, forKey: .customerID)
        try container.encode(self.origin, forKey: .origin)
        try container.encode(self.destination, forKey: .destination)
        try container.encode(self.distance, forKey: .distance)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.driver, forKey: .driver)
        try container.encode(self.value, forKey: .value)
    }
}
