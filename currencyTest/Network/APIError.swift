//
//  APIError.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 17.07.2023.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case badResponse(statusCode: Int)
    
    var description: String {
        switch self {
        case .badResponse(_):
            return "Something went wrong"
        }
    }
}
