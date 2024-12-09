//
//  MockExecutionError.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/9/24.
//

import Foundation
@testable import Travel

extension ExecutionError {
    static var mockData: Data? {
        let mockJSON = """
{
    "error_code": "INVALID_ID",
    "error_description": "Invalid client id"
}
"""
        
        return mockJSON.data(using: .utf8)
    }
}
