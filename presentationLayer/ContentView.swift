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
    @ObservedObject private var stationDataGetter = StationDataGetter()
    
    var body: some View {
        VStack {
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()
                .onAppear {
                    stationDataGetter.getStationData() {
                        DispatchQueue.main.async{
                            self.isDataFetched = true
                            print("Fetch Complete")
                        }
                    }
                }
            
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
                stationDataGetter.filterStationData(for: searchPostcode)
            }.buttonStyle(.bordered).disabled(!isDataFetched)
            
            if stationDataGetter.filteredStations.count > 0 {
                PriceListView(filteredStations: stationDataGetter.filteredStations)
                MapView(filteredStations: stationDataGetter.filteredStations)
            }
            
            
        }
        .padding()
    }
}
