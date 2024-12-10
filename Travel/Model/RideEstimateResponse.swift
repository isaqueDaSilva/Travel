//
//  RideEstimateResponse.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of the response body with all informations for an estimate ride.
struct RideEstimateResponse: Sendable {
    let id: UUID
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
    
    /// Total distance in kilometer
    var distanceInKM: Int {
        distance / 1000
    }
    
    init(origin: Location, destination: Location, distance: Int, duration: Int, options: [Driver]) {
        self.id = UUID()
        self.origin = origin
        self.destination = destination
        self.distance = distance
        self.duration = duration
        self.options = options
    }
}

extension RideEstimateResponse: Decodable {
    enum CodingKeys: CodingKey {
        case origin
        case destination
        case distance
        case duration
        case options
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.origin = try container.decode(RideEstimateResponse.Location.self, forKey: .origin)
        self.destination = try container.decode(RideEstimateResponse.Location.self, forKey: .destination)
        self.distance = try container.decode(Int.self, forKey: .distance)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.options = try container.decode([RideEstimateResponse.Driver].self, forKey: .options)
    }
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

extension RideEstimateResponse {
    typealias Review = Driver.Review
}

extension RideEstimateResponse: Hashable {
    static func == (lhs: RideEstimateResponse, rhs: RideEstimateResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
