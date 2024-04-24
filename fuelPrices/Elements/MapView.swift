//
//  MapView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    var filteredStations: [StationData]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
            
            Map() {
                ForEach(filteredStations, id: \.self) { station in
                    Marker(station.brand.uppercased(), systemImage: "fuelpump", coordinate: CLLocationCoordinate2D(latitude: station.location.latitude, longitude: station.location.longitude))
                        .tint(.green)
                }
            }
            .cornerRadius(5)
        }
        
    }
}
