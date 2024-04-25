//
//  ContentView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import SwiftUI

struct PostcodeCheckerView: View {
    
    @ObservedObject private var stationDataManager = PricesNearMeFinder()
    
    var body: some View {
        VStack {
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()
                .onAppear {
                    stationDataManager.getStationData() {
                        // TODO: this should store the data returnd to us. Move this code to the view model.
                        // TODO: an image should never trigger a network request
                    }
                }
            
            TextField("Enter the first part of your Postcode", text: $stationDataManager.postcode)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: stationDataManager.postcode) { userInput in
                    if userInput.count > 4 {
                        stationDataManager.postcode = String(userInput.prefix(4))
                    }
                }
            
            Button("Search Prices") {
                let searchPostcode = SearchPostcode(searchPostcode: stationDataManager.postcode)
                stationDataManager.filterStationData(for: searchPostcode, responses: stationDataManager.stationDataAPI.responses)
            }.buttonStyle(.bordered).disabled(!stationDataManager.stationDataAPI.isDataFetched)
            
            if stationDataManager.filteredStations.count > 0 {
                PriceListView(filteredStations: stationDataManager.filteredStations)
                MapView(filteredStations: stationDataManager.filteredStations)
            }
            
            
        }
        .padding()
    }
}
