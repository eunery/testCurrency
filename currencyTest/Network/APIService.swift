//
//  APIService.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 17.07.2023.
//

import Foundation

struct APIService: APIServiceProtocol {
    let formatter = DateFormatter()
    
    func getCurrenciesBetweenDates(completion: @escaping(Result<[Currency], APIError>) -> Void) {
        
        var url = URLComponents(string: "https://www.cbr.ru/scripts/XML_dynamic.asp")
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        let date2 = formatter.string(from: Date.now)
        let queryItems = [
            URLQueryItem(name: "date_req1", value: date1),
            URLQueryItem(name: "date_req2", value: date2),
            URLQueryItem(name: "VAL_NM_RQ", value: "R01235")
        ]
        url?.queryItems = queryItems
        
        let task = URLSession.shared.dataTask(with: (url?.url)!) {(data, response, error) in
            guard let data = data else {
                return
            }
            let parser = MonthlyXMlParser(data: data)
            if parser.parse() {
                KeychainManager.saveLastCurrency(number: parser.currencies[parser.currencies.count-2].value)
                completion(Result.success(parser.currencies))
            }
        }
        
        task.resume()
    }
    
    
    func getCurrentCurrency(completion: @escaping(Result<Double, APIError>) -> Void) {
        
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: Date.now)
        var url = URLComponents(string: "https://www.cbr.ru/scripts/XML_daily.asp")
        let queryItems = [
            URLQueryItem(name: "date_req", value: date)
        ]
        url?.queryItems = queryItems
        
        let task = URLSession.shared.dataTask(with: (url?.url)!) {(data, response, error) in
            guard let data = data else {
                return
            }
            let parser = CurrentXMLParser(data: data)
            if parser.parse() {
                if (parser.currency.value != KeychainManager.get(str: "currentCurrency")) {
                    KeychainManager.saveLastCurrency(number: KeychainManager.get(str: "currentCurrency"))
                    completion(Result.success(parser.currency.value))
                }
            }
        }
        
        task.resume()
    }
}
