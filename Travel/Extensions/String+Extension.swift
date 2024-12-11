//
//  String+Extension.swift
//  Travel
//
//  Created by Isaque da Silva on 12/11/24.
//

import Foundation

extension String {
    var date: Date {
        let newDateString = self + "Z"
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        
        let date = formatter.date(from: newDateString)
        
        guard let date else { return .now }
        
        return date
    }
}
