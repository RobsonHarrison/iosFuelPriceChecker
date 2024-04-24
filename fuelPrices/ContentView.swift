//
//  ContentView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isDataFetched = false
    @State private var postcode = ""
    @State private var stationDataGetter = StationDataGetter()
    
    var body: some View {
        VStack {
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()
            
            TextField("Enter the first part of your Postcode", text: $postcode)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: postcode) { userInput in
                    if userInput.count > 4 {
                        postcode = String(userInput.prefix(4))
                    }
                }
            
            Button("Search Prices") {
                let searchPostcode = SearchPostcode(searchPostcode: postcode)
                stationDataGetter.getStationData(for: searchPostcode) {
                    self.isDataFetched = true
                    
                }
            }.buttonStyle(.bordered)
            
            if isDataFetched {
                PriceListView(filteredStations: stationDataGetter.filteredStations)
                MapView(filteredStations: stationDataGetter.filteredStations)
            }
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
