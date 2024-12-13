//
//  PolylineDecodingAlgorithm_Test.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/12/24.
//

import XCTest
@testable import Travel

final class PolylineDecodingAlgorithm_Test: XCTestCase {
    
    func test_isPolylineDecodingAlgorithmDecodingAEncodedPolylineCorrectly() {
        // Source for the Values:
        // https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=pt-br#example
        
        let encodedPolyline = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
        let polyline = RouteResponse.Legs.Polyline(encodedPolyline: encodedPolyline)
        
        XCTAssertEqual(polyline.coordinates.count, 3)
        XCTAssertEqual(polyline.coordinates[0].latitude, 38.5)
        XCTAssertEqual(polyline.coordinates[0].longitude, -120.2)
        XCTAssertEqual(polyline.coordinates[1].latitude, 40.7)
        XCTAssertEqual(polyline.coordinates[1].longitude, -120.95)
        XCTAssertEqual(polyline.coordinates[2].latitude, 43.252)
        XCTAssertEqual(polyline.coordinates[2].longitude, -126.453)
    }
}
