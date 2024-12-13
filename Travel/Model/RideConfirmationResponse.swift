//
//  RideConfirmationResponse.swift
//  Travel
//
//  Created by Isaque da Silva on 12/6/24.
//

import Foundation

/// Representation of a confirmation status to a ride request.
struct RideConfirmationResponse: Sendable {
    /// Represents the confirmation status for a ride.
    let isSuccessed: Bool
}

// MARK: - Decoding -
extension RideConfirmationResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case isSuccessed = "success"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isSuccessed = try container.decode(Bool.self, forKey: .isSuccessed)
    }
}
