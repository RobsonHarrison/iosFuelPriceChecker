//
//  PriceListView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI

struct PriceListView: View {
    var filteredStations: [FuelStation]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(filteredStations, id: \.site_id) { station in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(station.brand.uppercased())
                            .font(.title)
                        Text("\(station.postcode.uppercased())")
                            .font(.caption)
                        Link(destination: URL(string: "http://maps.apple.com/?q=\(station.location.latitude),\(station.location.longitude)")!) {
                            HStack {
                                Image(systemName: "car.circle")
                                    .foregroundColor(Color(red: 1.0 / 255.0, green: 127.0 / 255.0, blue: 113.0 / 255.0))
                                Text("Open in Maps")
                                    .font(.caption)
                                    .foregroundColor((Color(red: 1.0 / 255.0, green: 127.0 / 255.0, blue: 113.0 / 255.0)))
                            }
                        }

                        .foregroundColor(.blue)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            if station.prices.E10 != nil {
                                Text("Standard Unleaded (E10):")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if station.prices.E5 != nil {
                                Text("Premium Unleaded (E5):")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if station.prices.B7 != nil {
                                Text("Standard Diesel:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if station.prices.SDV != nil {
                                Text("Premium Diesel:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        VStack(alignment: .trailing) {
                            if let e10Price = station.prices.formattedE10 {
                                Text("\(e10Price)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if let e5Price = station.prices.formattedE5 {
                                Text("\(e5Price)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if let b7Price = station.prices.formattedB7 {
                                Text("\(b7Price)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            if let sdvPrice = station.prices.formattedSDV {
                                Text("\(sdvPrice)")
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
