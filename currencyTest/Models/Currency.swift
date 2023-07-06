//
//  Currency.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 01.07.2023.
//

import Foundation

struct Currency: Identifiable {
    let id = UUID()
    var date: String
    var value: Double
}
