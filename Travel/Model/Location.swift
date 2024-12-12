//
//  Location.swift
//  Travel
//
//  Created by Isaque da Silva on 12/11/24.
//

import Foundation

/// Representation of some location in the world by latitude and longitude values.
struct Location: Sendable, Decodable {
    let latitude: Double
    let longitude: Double
}
