//
//  CurrentViewModel.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 16.07.2023.
//

import Foundation
import SwiftUI

class CurrentViewModel: ObservableObject {
    @Published var currentCurrency: Double = KeychainManager.get(str: "currentCurrency")
    @Published var lastCurrency: Double = KeychainManager.get(str: "lastCurrency")
    @Published var isPositiveCurrency: Bool = false
    @Published var currencyColorBySign: Color = Color.black
    @Published var todayDate: String = ""
    let formatter = DateFormatter()
    let service: APIServiceProtocol
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
        getCurrency()
        self.todayDate = formatter.string(from: Date.now)
    }
    
    func getCurrency() {
        service.getCurrentCurrency() { [unowned self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let currency):
                    self.currentCurrency = currency
                case .failure(let error):
                    print(error)
                }
            }
        }
        checkDelta()
    }
    
    func checkDelta() {
        if (self.lastCurrency > self.currentCurrency) {
            self.isPositiveCurrency = false
            self.currencyColorBySign = .red
        } else {
            self.currencyColorBySign = .green
            self.isPositiveCurrency = true
        }
    }
}
