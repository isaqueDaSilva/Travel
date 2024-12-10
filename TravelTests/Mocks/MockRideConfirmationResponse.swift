//
//  MockRideConfirmationResponse.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/10/24.
//

import Foundation
@testable import Travel

extension RideConfirmationResponse {
    static var mockData: Data? {
        let mockJSON = """
{
    "success": true
}
"""
        return mockJSON.data(using: .utf8)
    }
}
