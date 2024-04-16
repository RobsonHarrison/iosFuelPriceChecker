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
            
            TextField("Enter Postcode", text: $postcode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                            
            Button("Fetch Data") {
                            stationDataGetter.getStationData {
                                self.isDataFetched = true
                                
                            }
                        }.buttonStyle(.bordered)
            
            if isDataFetched {
                            Text("Data fetched successfully!")
                                .foregroundColor(.blue)
                        }
            
            
        }
        
        
        
        .padding()
    }
    
       }


#Preview {
    ContentView()
}
