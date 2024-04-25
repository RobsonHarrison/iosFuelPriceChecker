//
//  StationDataManager.swift
//  fuelPrices
//
//  Created by Robson Harrison on 25/04/2024.
//

import Foundation

class StationDataManager: ObservableObject {
    @Published var postcode = ""
    @Published var filteredStations: [StationData] = []
    
    
    func filterStationData(for postcode: SearchPostcode, responses: [ResponseData]) {
        let searchPostcode = postcode.searchPostcode.uppercased()
        guard !searchPostcode.isEmpty else {
            filteredStations.removeAll()
            return
        }
        filteredStations.removeAll()
        var tempFilteredStations = [StationData]()
        for response in responses {
            for station in response.stations {
                if station.postcode.hasPrefix(searchPostcode) {
                    if !tempFilteredStations.contains(where: { $0.site_id == station.site_id }){
                        tempFilteredStations.append(station)
                    }
                }
            }
        }
        filteredStations = tempFilteredStations
    }
}

