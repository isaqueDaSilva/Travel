//
//  RouteResponse.swift
//  Travel
//
//  Created by Isaque da Silva on 12/11/24.
//

import CoreLocation
import Foundation

/// Representation of the response body for a route of a requested ride.
struct RouteResponse: Sendable {
    typealias Legs = Route.Legs
    typealias Polyline = Legs.Polyline
 
    /// A list with all routes avaiable for  a requested ride.
    let routes: [Route]?
}

// MARK: - Decoding -
extension RouteResponse: Decodable {
    enum CodingKeys: CodingKey {
        case routes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.routes = try container.decodeIfPresent([RouteResponse.Route].self, forKey: .routes)
    }
}

extension RouteResponse {
    /// Representation of a single route retorned.
    struct Route: Sendable {
        let id: UUID
        let legs: [Legs]
        
        var coordinates: [CLLocationCoordinate2D] {
            guard !legs.isEmpty else { return [] }
            return legs[0].polyline.coordinates
        }
    }
}

extension RouteResponse.Route: Decodable {
    enum CodingKeys: CodingKey {
        case legs
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.legs = try container.decode([Legs].self, forKey: RouteResponse.Route.CodingKeys.legs)
    }
    
    init(legs: [Legs]) {
        self.id = UUID()
        self.legs = legs
    }
}

extension RouteResponse.Route {
    struct Legs: Sendable, Decodable {
        let polyline: Polyline
    }
}

extension RouteResponse.Legs {
    struct Polyline: Sendable, Decodable {
        let encodedPolyline: String
    }
}

extension RouteResponse.Polyline {
    /// A list with all coordinates of the route's ride.
    ///
    /// This Property gets a String value of an ecoded polyline version and decodes into a list of `CLLocationCoordinate2D`,
    /// using a reverse engineering of Google's encode polyline algorithm, when each point is represented
    /// as incremental difference in relashion of the previous point.
    ///
    /// >Tip: To see, more checks the Google's encode algorithm article in developer page:
    /// <https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=pt-br#example>
    var coordinates: [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        var currentIndex = encodedPolyline.startIndex
        let length = encodedPolyline.count
        
        var latitude: Int32 = 0
        var longitude: Int32 = 0
        
        while currentIndex < encodedPolyline.endIndex {
            // Decodes a new latitude value.
            let latChange = decodeValue(currentIndex: &currentIndex, length: length)
            
            // Increments the current longitude
            // with decoded value to gets a new
            // latitude value.
            latitude += latChange
            
            // Decodes a new longitude value
            let lngChange = decodeValue(currentIndex: &currentIndex, length: length)
            
            // Increments the current longitude
            // with decoded value to gets a new
            // longitude value.
            longitude += lngChange
            
            // Divides the latitude value by 100000
            // to gets a valid latitude.
            let finalLatitude = Double(latitude) / 1e5
            
            // Divides the logitude value by 100000
            // to gets a valid longitude.
            let finalLongitude = Double(longitude) / 1e5
            
            coordinates.append(.init(latitude: finalLatitude, longitude: finalLongitude))
        }
        
        return coordinates
    }
    
    /// Decodes an individual value of an ecoded polyline.
    /// - Parameters:
    ///   - currentIndex: The current index of the processed string.
    ///   - length: The total amount of values in the string.
    /// - Returns: Returns a Int32 representation of the processed String.
    private func decodeValue(currentIndex: inout String.Index, length: Int) -> Int32 {
        var result: Int32 = 0
        var shift: Int32 = 0
        var byte: Int32 = 0

        repeat {
            // Gets a character by the current Index Value
            let character = encodedPolyline[currentIndex]
            
            // Advance by 1, when the current index isn't the last index.
            encodedPolyline.formIndex(after: &currentIndex)
            
            // Converting the current character value
            // into a number representation of ASCII character
            // and subtract by 63 to get the original value.
            byte = Int32(character.asciiValue!) - 63
            
            // Peforms a clean up, removing the MSB,
            // and maintaining the the last 5 LSB,
            // by comparing the current byte and 0x1F(31),
            // using AND opeartion with the
            // and then, shift left with the current
            // amount of shift.
            // Finaly, peforms a comparation between
            // the current result and the byte value
            // using OR operation and combines the
            // two values, to reconstruct the actual value.
            result |= (byte & 0x1F) << shift
            
            // Increase by 5 the current shift value
            // for don't subscribe the previous bits.
            shift += 5
        } while byte >= 0x20 // Continues the loop when the MSB is 1.

        // Checks the LSB,
        // if is 1, the number negative
        // if 0 is positive.
        // and then, we peforms a
        // specific opearation
        // for each case.
        if (result & 1) == 1 {
            // If 1, the number is negative
            // and we need to shift right
            // the bits and then,
            // invert the bits
            // to get the real number.
            result = ~(result >> 1) // Two's Complement Operation
        } else {
            // If 0, the number is positive
            // and we only needs to shift
            // right to get the real number
            result >>= 1
        }
        
        // Return the final result
        return result
    }
}
