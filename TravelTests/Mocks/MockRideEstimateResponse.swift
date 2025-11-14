//
//  MockRideEstimateResponse.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation
@testable import Travel

extension RideEstimateResponse {
    static var mockData: Data? {
        let mockJSON = """
{
    "origin": {
        "latitude": 37.334606,
        "longitude": -122.009102
    },
    "destination": {
        "latitude": 37.33182,
        "longitude": -122.03118
    },
    "distance": 4,
    "duration": 6,
    "options": [
        {
          "id": 1,
          "name": "Tim Cook",
          "description": "Nice to meet you, I'm Tim. You can come in and enjoy the trip, because with my skills I will take you to your destination, focusing on your safety, agility and satisfaction. Just don't talk to me too much, because I don't like being interrupted when I'm concentrating.",
          "vehicle": "Tesla Model 3",
          "review": {
            "rating": 4,
            "comment": "Have a good trip. It met my expectations despite the price."
          },
          "value": 10.0
        }
    ],
    "routeResponse": {
        "routes": [
            {
                "legs": [
                    {
                        "polyline": {
                            "encodedPolyline": "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
                        }
                    }
                ]
            }
        ]
    }
}
"""
        
        return mockJSON.data(using: .utf8)
    }
}
