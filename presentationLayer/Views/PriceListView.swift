//
//  StationPriceList.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI

struct PriceListView: View {
    
    var filteredStations: [PetrolStation]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                ForEach(filteredStations, id: \.site_id) { station in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(station.brand.uppercased())")
                            .font(.title)
                        Text("\(station.postcode.uppercased())")
                            .font(.caption)
                        Link(destination: URL(string: "http://maps.apple.com/?q=\(station.location.latitude),\(station.location.longitude)")!) {
                            HStack {
                                Image(systemName: "car.circle")
                                    .foregroundColor(.blue)
                                Text("Open in Maps")
                                    .font(.caption)
                            }
                        }

                            .foregroundColor(.blue)
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                if station.prices.E10 != nil {
                                    Text("Unleaded (E10):")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if station.prices.E5 != nil {
                                    Text("Unleaded (E5):")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if station.prices.B7 != nil {
                                    Text("Diesel:")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                if let e10Price = station.prices.E10 {
                                    Text("\(e10Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let e5Price = station.prices.E5 {
                                    Text("\(e5Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                if let b7Price = station.prices.B7 {
                                    Text("\(b7Price)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        Divider()
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }

