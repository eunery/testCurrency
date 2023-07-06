//
//  ContentView.swift
//  currencyTest
//
//  Created by Sergei Kulagin on 01.07.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Current().tabItem {
                Text("Текущий курс")
            }
            Monthly().tabItem {
                Text("Месячный курс")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
