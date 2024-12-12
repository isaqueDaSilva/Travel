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
        let polyline: Polyline
    }
}

extension RouteResponse.Legs {
    struct Polyline: Decodable {
        let encodedPolyline: String
    }
}

extension RouteResponse.Polyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        var index = encodedPolyline.startIndex
        let length = encodedPolyline.count
        
        var latitude: Int32 = 0
        var longitude: Int32 = 0
        
        while index < encodedPolyline.endIndex {
            // Decodificar Latitude
            let latChange = decodeValue(currentIndex: &index, length: length)
            latitude += latChange
            
            // Decodificar Longitude
            let lngChange = decodeValue(currentIndex: &index, length: length)
            longitude += lngChange
            
            let finalLatitude = Double(latitude) / 1e5
            let finalLongitude = Double(longitude) / 1e5
            
            coordinates.append(.init(latitude: finalLatitude, longitude: finalLongitude))
        }
        
        return coordinates
    }
    
    private func decodeValue(currentIndex: inout String.Index, length: Int) -> Int32 {
        var result: Int32 = 0
        var shift: Int32 = 0
        var byte: Int32 = 0

        repeat {
            // Pega o caractere atual e avança o índice
            let character = encodedPolyline[currentIndex]
            encodedPolyline.formIndex(after: &currentIndex)
            
            // Converte o caractere para o valor correspondente
            byte = Int32(character.asciiValue!) - 63
            
            // Remove o bit de sinal extra e ajusta para posição
            result |= (byte & 0x1F) << shift
            shift += 5
        } while byte >= 0x20 // Continua enquanto o bit mais significativo for 1

        // Verifica se o valor é negativo (complemento de dois)
        if (result & 1) == 1 {
            result = ~(result >> 1) // Negativo
        } else {
            result >>= 1 // Positivo
        }
        
        return result
    }
}
