//
//  DecodeData.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

///  Sets a method to process a decoding action for a decodable model.
enum DecodeData {
    static func decode<T: Decodable>(_ data: Data, for model: T.Type) throws(ExecutionError) -> T {
        let decoder = JSONDecoder()
        
        guard let model = try? decoder.decode(T.self, from: data) else {
            throw .decodeError
        }
        
        return model
    }
}
