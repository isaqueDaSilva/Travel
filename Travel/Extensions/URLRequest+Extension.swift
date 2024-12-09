//
//  URLRequest+Extension.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import Foundation

extension URLRequest {
    /// Sets the HTTP method that the URLRequest will be used to prcess the request.
    mutating func setHTTPMethod(_ method: HTTPMethod) {
        self.httpMethod = method.rawValue
        
        if method == .patch || method == .post {
            self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
