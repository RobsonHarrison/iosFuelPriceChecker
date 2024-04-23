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
                
                //                Remove to own view file
                
                VStack(alignment: .leading) {
                    ForEach(stationDataGetter.filteredStations, id: \.self) { item in
                        Text("\(item.brand)")
                            .font(.title)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                if let e10Price = item.prices.E10 {
                                    Text("Unleaded (E10):")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let e5Price = item.prices.E5 {
                                    Text("Unleaded (E5):")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let b7Price = item.prices.B7 {
                                    Text("Diesel:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                if let e10Price = item.prices.E10 {
                                    Text("\(e10Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let e5Price = item.prices.E5 {
                                    Text("\(e5Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let b7Price = item.prices.B7 {
                                    Text("\(b7Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        Divider()
                    }
                }

                
                //                Code end
                
                
            }
            
            
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
