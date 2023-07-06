//
//  KeychainManager.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 02.07.2023.
//

import Foundation

class KeychainManager {
    
    static let defaults = UserDefaults.standard
    
    static func saveCurrent(number: Double) {
        defaults.set(number, forKey: "currentCurrency")
    }
    
    static func saveLastCurrency(number: Double) {
        defaults.set(number, forKey: "lastCurrency")
    }
    
    static func get(str: String) -> Double {
        return defaults.double(forKey: str)
    }
    
    static func delete(str: String) {
        UserDefaults.standard.removePersistentDomain(forName: str)
    }
    
}
