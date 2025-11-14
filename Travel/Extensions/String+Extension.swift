//
//  String+Extension.swift
//  Travel
//
//  Created by Isaque da Silva on 12/11/24.
//

import Foundation

extension String {
    /// Getting a ISO 8601 string and transformer into a Foundation's Date format.
    var date: Date {
        // Checking if the last word is Z.
        let isLastWordZ = self.last == "Z"
        
        // Creating a new string based on your last element.
        // If the last element is Z, will be use the same getted string.
        // If not, will add a Z on end of the String to matches as
        // ISO8601DateFormatter formatter expects.
        let newDateString = isLastWordZ ? self : self + "Z"
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        
        let date = formatter.date(from: newDateString)
        
        guard let date else { return .now }
        
        return date
    }
}
