//
//  StationPriceList.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI

struct StationPriceListView: View {
    
    var filteredStations: [StationData]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(filteredStations, id: \.self) { item in
                Text("\(item.brand.uppercased())")
                    .font(.title)
                
                HStack {
                    VStack(alignment: .leading) {
                        if item.prices.E10 != nil {
                            Text("Unleaded (E10):")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if item.prices.E5 != nil {
                            Text("Unleaded (E5):")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if item.prices.B7 != nil {
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
    }}
