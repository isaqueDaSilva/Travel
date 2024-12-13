//
//  RideEstimateRequest.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation body for request an estimate ride.
struct RideEstimateRequest: Sendable {
    /// Customer's unique identifier.
    let customerID: String
    
    /// Start point of this ride.
    let origin: String
    
    /// End poinr of this ride.
    let destination: String
}

// MARK: - Encoding Method -
extension RideEstimateRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case origin = "origin"
        case destination = "destination"
    }
    
    /// Encodes this struct into a apropriate format with aproprieted keys.
    ///
    /// This struct will be transformed into a same format as the following sample JSON:
    /// ```JSON
    ///{
    ///     "customer_id": "CT01",
    ///     "origin": "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
    ///     "destination": "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"
    ///}
    /// ```
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.customerID, forKey: .customerID)
        try container.encode(self.origin, forKey: .origin)
        try container.encode(self.destination, forKey: .destination)
    }
}
