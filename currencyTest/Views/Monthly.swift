//
//  Monthly.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 02.07.2023.
//

import SwiftUI

struct Monthly: View {
    @StateObject var viewModel = MonthlyViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Курс доллара за последний месяц").padding(.top, 5).font(.custom("", size: 26))
            List {
                ForEach(viewModel.currencies) { item in
                    HStack{
                        Text("\(item.date)")
                        Spacer()
                        Text("\(String(format: "%.4f", item.value))")
                    }
                }
            }.cornerRadius(10)
        }
        .padding()
    }
}

struct Monthly_Previews: PreviewProvider {
    static var previews: some View {
        Monthly()
    }
}
