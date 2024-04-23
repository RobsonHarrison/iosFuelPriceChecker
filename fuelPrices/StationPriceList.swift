//
//  StationPriceList.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI

struct StationPriceList: View {
    
    @State private var stationDataGetter = StationDataGetter()
    
    var body: some View {
        
        Text("List View")
        
        VStack(alignment: .leading) {
            ForEach(stationDataGetter.filteredStations, id: \.self) { item in
                Text("\(item.brand)")
                    .font(.title)

                HStack {
                    Text("Fuel Type")
                    Spacer()
                    Text("Price")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
            }
        }
    }}

#Preview {
    StationPriceList()
}
