//
//  ContentView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import SwiftUI

struct PostcodeCheckerView: View {
    
    @ObservedObject private var stationDataAPI = StationDataAPI()
    @ObservedObject private var stationDataManager = StationDataManager()
    
    var body: some View {
        VStack {
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()
                .onAppear {
                    stationDataAPI.getStationData() {
                        DispatchQueue.main.async{
                            
                        }
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
                stationDataManager.filterStationData(for: searchPostcode, responses: stationDataAPI.responses)
            }.buttonStyle(.bordered).disabled(!stationDataAPI.isDataFetched)
            
            if stationDataManager.filteredStations.count > 0 {
                PriceListView(filteredStations: stationDataManager.filteredStations)
                MapView(filteredStations: stationDataManager.filteredStations)
            }
            
            
        }
        .padding()
    }
}
