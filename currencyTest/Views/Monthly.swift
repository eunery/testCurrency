//
//  Monthly.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 02.07.2023.
//

import SwiftUI

struct Monthly: View {
    @State var currencies: [Currency] = [Currency]()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Курс доллара за последний месяц").padding(.top, 5).font(.custom("", size: 26))
            List {
                ForEach(currencies) { item in
                    HStack{
                        Text("\(item.date)")
                        Spacer()
                        Text("\(item.value)")
                    }
                }
            }.cornerRadius(10)
        }
        .padding()
        .onAppear {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date1 = formatter.string(from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
            let date2 = formatter.string(from: Date.now)
            
            var url = URLComponents(string: "https://www.cbr.ru/scripts/XML_dynamic.asp")
            let queryItems = [URLQueryItem(name: "date_req1", value: date1), URLQueryItem(name: "date_req2", value: date2), URLQueryItem(name: "VAL_NM_RQ", value: "R01235")]
            url?.queryItems = queryItems
            
            let task = URLSession.shared.dataTask(with: (url?.url)!) {(data, response, error) in guard let data = data else {return}
                let parser = MonthlyXMlParser(data: data)
                if parser.parse() {
                    currencies = parser.currencies
                    KeychainManager.saveLastCurrency(number: parser.currencies[parser.currencies.count-2].value)
                }
            }
            
            task.resume()
        }
    }
}

struct Monthly_Previews: PreviewProvider {
    static var previews: some View {
        Monthly()
    }
}
