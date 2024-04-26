//
//  MapView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/04/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var position: MapCameraPosition = .automatic
    var filteredStations: [PetrolStation]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
            
            Map(position: $position) {
                ForEach(filteredStations, id: \.site_id) { station in
                    Marker(station.brand.uppercased(), systemImage: "fuelpump", coordinate: CLLocationCoordinate2D(latitude: station.location.latitude, longitude: station.location.longitude))
                        .tint(.green)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .cornerRadius(5)
            .onChange(of: filteredStations){
                position = .automatic
            }
        }
        
    }
}
