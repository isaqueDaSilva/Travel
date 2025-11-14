//
//  Endpoint.swift
//  Travel
//
//  Created by Isaque da Silva on 12/7/24.
//

import Foundation

// TODO: Update module from URL based to Swift HTTP Types.

/// Sets a set of defaults endpoints that will be used to process request in the app.
enum Endpoint {
    /// This endpoint is used to process and get estimated buget to a ride.
    case estimate
    
    /// This endpoint is used to informes to the system that the user chosen a driver
    /// and he wants to make the ride.
    case confirm
    
    /// This endpoint is used to get the history of rides made by user.
    case history(String, String)
    
    /// Sets a endpoint String representation of for each endpoints case.
    private var endpoint: String {
        switch self {
        case .estimate:
            "estimate"
        case .confirm:
            "confirm"
        case .history(let customerID, let driverID):
            "\(customerID)?driver_id=\(driverID)"
        }
    }
    
    /// Creates an URL representation for a chosen endpoint.
    var url: URL? {
        let urlString = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/\(self.endpoint)"
        let url = URL(string: urlString)
        
        return url
    }
}
