//
//  MockCustomerRideHistory.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/11/24.
//

import Foundation
@testable import Travel

extension CustomerRideHistory {
    static var mockData: Data? {
        let mockJSON = """
{
    "customer_id": "01",
    "rides": [
        {
            "id": 1,
            "date": "2024-08-18T16:04:00",
            "origin": "Apple Park",
            "destination": "Apple Infinity Loop",
            "distance": 7.0,
            "duration": "7:34",
            "driver": {
                "id": 1,
                "name": "Tim Cook"
            },
            "value": 15.00
        }
    ]
}
"""
        
        return mockJSON.data(using: .utf8)
    }
}
