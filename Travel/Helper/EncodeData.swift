//
//  EncodeData.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

// TODO: Create an unique module that handles with encode and decode data.

/// Sets a method to process an encoding action for an encodable model.
enum EncodeData {
    static func encode<T: Encodable>(data: T) throws(ExecutionError) -> Data {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            throw .encodeError
        }
        
        return encodedData
    }
}
