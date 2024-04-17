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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Fuel Price")
            Text((postcode))
            
            TextField("Enter Postcode", text: $postcode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button("Fetch Data") {
                let searchPostcode = SearchPostcode(searchPostcode: postcode)
                stationDataGetter.getStationData(for: searchPostcode) {
                    self.isDataFetched = true
                    
                }
            }.buttonStyle(.bordered)
            
            if isDataFetched {
                Text("Data fetched successfully!")
                    .foregroundColor(.blue)
         
                let stationsBrand = Dictionary(grouping: stationDataGetter.filteredStations, by: { $0.brand })

          
                let formattedPrices = stationsBrand.map { brand, stations in
                    var formattedText = "\(brand):\n"
                    
                    for station in stations {
                        if let e10Price = station.prices.E10 {
                            formattedText += "  Unleaded (E10): \(e10Price)\n"
                        }
                        
                        if let e5Price = station.prices.E5 {
                            formattedText += "  Unleaded (E5): \(e5Price)\n"
                        }
                        
                        if let b7Price = station.prices.B7 {
                            formattedText += "  Diesel: \(b7Price)\n"
                        }
                    }
                    
                    return formattedText
                }

                // Join the formatted prices and display
                Text(formattedPrices.joined(separator: "\n"))



            
                
            }
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
