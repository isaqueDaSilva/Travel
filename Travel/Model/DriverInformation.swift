//
//  DriverInformation.swift
//  Travel
//
//  Created by Isaque da Silva on 12/7/24.
//

import Foundation

/// Representation with information of a chosen driver.
struct DriverInformation: Sendable, Codable {
    /// Unique identifier of the driver.
    let id: Int
    
    /// Name of the chosen driver.
    let name: String
}
