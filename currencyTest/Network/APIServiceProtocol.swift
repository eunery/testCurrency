//
//  APIServiceProtocol.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 17.07.2023.
//

import Foundation

protocol APIServiceProtocol {
    
    func getCurrenciesBetweenDates(completion: @escaping(Result<[Currency], APIError>) -> Void)
    
    func getCurrentCurrency(completion: @escaping(Result<Double, APIError>) -> Void)
}
