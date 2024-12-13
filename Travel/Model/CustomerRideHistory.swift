//
//  CustomerRideHistory.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of the ride's history made by a customer.
struct CustomerRideHistory: Sendable {
    /// Customer's unique identifier.
    let customerID: String
    
    /// List of all rides made by the customer.
    let rides: [Ride]
}

// MARK: - Decoding CustomerRideHistory -
extension CustomerRideHistory: Decodable {
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case rides = "rides"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.customerID = try container.decode(String.self, forKey: .customerID)
        self.rides = try container.decode([Ride].self, forKey: .rides)
    }
}

extension CustomerRideHistory {
    /// Representation of a single ride made by a user.
    struct Ride: Sendable {
        let internalID: UUID
        
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
        
        var approximateDistance: Double {
            distance.rounded(.toNearestOrAwayFromZero)
        }
        
        init(
            id: Int,
            date: Date,
            origin: String,
            destination: String,
            distance: Double,
            duration: String,
            driver: DriverInformation,
            value: Double
        ) {
            self.internalID = .init()
            self.id = id
            self.date = date
            self.origin = origin
            self.destination = destination
            self.distance = distance
            self.duration = duration
            self.driver = driver
            self.value = value
        }
    }
}

// MARK: - Decoding CustomerRideHistory.Ride -
extension CustomerRideHistory.Ride: Decodable {
    enum CodingKeys: CodingKey {
        case id
        case date
        case origin
        case destination
        case distance
        case duration
        case driver
        case value
    }
    
    init(from decoder: any Decoder) throws {
        self.internalID = .init()
        
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let dateString = try container.decode(String.self, forKey: .date)
        
        let date = dateString.date
        
        self.date = date
        
        self.origin = try container.decode(String.self, forKey: .origin)
        self.destination = try container.decode(String.self, forKey: .destination)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.duration = try container.decode(String.self, forKey: .duration)
        self.driver = try container.decode(DriverInformation.self, forKey: .driver)
        self.value = try container.decode(Double.self, forKey: .value)
    }
}
