//
//  RouteResponse.swift
//  Travel
//
//  Created by Isaque da Silva on 12/11/24.
//

import CoreLocation
import Foundation

struct RouteResponse: Decodable {
    typealias Legs = Route.Legs
    typealias Polyline = Legs.Polyline
 
    let routes: [Route]
}

extension RouteResponse {
    struct Route: Decodable {
        let id: UUID
        let legs: [Legs]
        
        var coordinates: [CLLocationCoordinate2D] {
            guard !legs.isEmpty else { return [] }
            return legs[0].polyline.coordinates
        }
        
        enum CodingKeys: CodingKey {
            case legs
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<RouteResponse.Route.CodingKeys> = try decoder.container(keyedBy: RouteResponse.Route.CodingKeys.self)
            self.id = UUID()
            self.legs = try container.decode([RouteResponse.Route.Legs].self, forKey: RouteResponse.Route.CodingKeys.legs)
        }
        
        init(legs: [Legs]) {
            self.id = UUID()
            self.legs = legs
        }
    }
}

extension RouteResponse.Route {
    struct Legs: Decodable {
        let distanceMeters: Int
        let duration: String
        let startLocation: StepLocation
        let endLocation: StepLocation
        let polyline: Polyline
    }
}

extension RouteResponse.Legs {
    struct StepLocation: Decodable {
        let latLng: Location
    }
}

extension RouteResponse.Legs {
    struct Polyline: Decodable {
        let encodedPolyline: String
    }
}

extension RouteResponse.Polyline {
    var coordinates: [CLLocationCoordinate2D] {
        // Stores the coordinates to display a route in the Map View
        var coordinates: [CLLocationCoordinate2D] = []
        
        var currentIndex = encodedPolyline.startIndex
        let endIndex = encodedPolyline.endIndex
        
        var latitude: Int32 = 0
        var longitude: Int32 = 0
        
        while currentIndex < endIndex {
            let (latChange, nextIndex) = decodeSingleCoordinate(startingAt: currentIndex)
            latitude += latChange
            currentIndex = nextIndex
            
            let (lngChange, newIndex) = decodeSingleCoordinate(startingAt: currentIndex)
            longitude += lngChange
            currentIndex = newIndex
            
            // Given the value and dividing by 100000
            // to get the latititude and logitude values.
            let lat = Double(latitude) / 1E5
            let lng = Double(longitude) / 1E5
            
            coordinates.append(.init(latitude: lat, longitude: lng))
        }
        
        return coordinates
    }
    
    private func decodeSingleCoordinate(startingAt index: String.Index) -> (Int32, String.Index) {
        var result: Int32 = 0
        var shift: Int32 = 0
        var currentIndex = index
        
        while currentIndex < encodedPolyline.endIndex {
            let char = encodedPolyline[currentIndex]
            let value = Int32(char.asciiValue! - 63)
            let bit = value & 0x1F
            result |= (bit << shift)
            shift += 5
            
            currentIndex = encodedPolyline.index(after: currentIndex)
            
            if value & 0x20 == 0 {
                break
            }
        }
        
        let finalResult = (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
        
        return (finalResult, currentIndex)
    }
}
