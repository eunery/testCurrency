//
//  MonthlyViewModel.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 16.07.2023.
//

import Foundation


class MonthlyViewModel: ObservableObject {
    @Published var currencies: [Currency] = [Currency]()
    @Published var isLoading: Bool = false
    let service: APIServiceProtocol
    let formatter = DateFormatter()
    
    init(service: APIServiceProtocol = APIService()) {
        self.service = service
        getCurrencies()
    }
    
    func getCurrencies() {

        service.getCurrenciesBetweenDates() { [unowned self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let currencies):
                    self.currencies = currencies
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
