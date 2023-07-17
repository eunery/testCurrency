//
//  Current.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 02.07.2023.
//

import SwiftUI
import BackgroundTasks

struct Current: View {
    @StateObject var viewModel = CurrentViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Текущий курс").font(.custom("", size: 26))
            HStack{
                Text("\(viewModel.todayDate)")
                Spacer()
                HStack {
                    Text("\(String(format: "%.4f", viewModel.currentCurrency))").padding(.trailing, 5)
                    Text("\(String(format: "%.4f", viewModel.currentCurrency - viewModel.lastCurrency))").foregroundColor(viewModel.currencyColorBySign)
                    Image(viewModel.isPositiveCurrency == true ? "arrowTopRight" : "arrowBottomRight").resizable().frame(width: 20, height: 20).foregroundColor(viewModel.currencyColorBySign)
                }
            }
            .cornerRadius(10)
            .padding(.top, 10)
            Spacer()
        }
        .padding()
    }
}

struct Current_Previews: PreviewProvider {
    static var previews: some View {
        Current()
    }
}
