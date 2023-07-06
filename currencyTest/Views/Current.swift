//
//  Current.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 02.07.2023.
//

import SwiftUI
import BackgroundTasks

struct Current: View {
    @State var currentCurrency: Double = KeychainManager.get(str: "currentCurrency")
    @State var lastCurrency: Double = KeychainManager.get(str: "lastCurrency")
    @State var bool = true
    @State var color = Color.black
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: Date.now)
        return date
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Текущий курс").font(.custom("", size: 26))
            HStack{
                Text("\(date)")
                Spacer()
                HStack {
                    Text("\(String(format: "%.4f", currentCurrency))").padding(.trailing, 5)
                    Text("\(String(format: "%.4f", currentCurrency - lastCurrency))").foregroundColor(color)
                    Image(bool == true ? "arrowTopRight" : "arrowBottomRight").resizable().frame(width: 20, height: 20).foregroundColor(color)
                }
            }
            .cornerRadius(10)
            .padding(.top, 10)
//            Button("Check user defaults",
//            action: {
//                print("Current value:")
//                print(KeychainManager.get(str: "currentCurrency"))
//
//                print("Previous value:")
//                print(KeychainManager.get(str: "lastCurrency"))
//                bool.toggle()
//            })
            Spacer()
        }
        .padding()
        .onAppear() {
            fetchData()
            checkDelta()
        }
    }
    
    func fetchData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: Date.now)
        
        var url = URLComponents(string: "https://www.cbr.ru/scripts/XML_daily.asp")
        let queryItems = [URLQueryItem(name: "date_req", value: date)]
        url?.queryItems = queryItems
        
        let task = URLSession.shared.dataTask(with: (url?.url)!) {(data, response, error) in guard let data = data else {return}
            let parser = CurrentXMLParser(data: data)
            if parser.parse() {
                if (parser.currency.value != self.currentCurrency) {
                    KeychainManager.saveLastCurrency(number: currentCurrency)
                    currentCurrency = parser.currency.value
                }
            }
        }
        
        task.resume()
    }
    
    func checkDelta() {
        if (lastCurrency > currentCurrency) {
            bool = false
            color = .red
        } else {
            color = .green
            bool = true
        }
    }
}

struct Current_Previews: PreviewProvider {
    static var previews: some View {
        Current()
    }
}
