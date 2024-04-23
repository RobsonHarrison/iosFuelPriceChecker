//
//  StationDataGetter.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import Foundation


class StationDataGetter {
    
    var responses: [ResponseData] = []
    var filteredStations: [StationData] = []
    
    func getStationData(for postcode: SearchPostcode, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for (fuelProvider, jsonUrl) in FuelProviderDictionary.fuelProviders {
            guard let url = URL(string: jsonUrl) else {
                print("Invalid URL for \(fuelProvider): \(jsonUrl)")
                continue
            }
            
            dispatchGroup.enter()
            
            let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
                defer {
                    dispatchGroup.leave()
                }
                
                if let error = error {
                    print("Error downloading data for \(fuelProvider) from \(url): \(error)")
                    return
                }
                guard let data = data else {
                    print("Error: No data received for \(fuelProvider) from \(url)")
                    return
                }
                
                do {
                    let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                    responses.append(responseData)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
            self.filterStationData(for: postcode)
            
        }
    }
    
    func filterStationData(for postcode: SearchPostcode) {
        let searchPostcode = postcode.searchPostcode.uppercased()
        responses.forEach { response in
            response.stations.forEach { station in
                if station.postcode.hasPrefix(searchPostcode) {
                    if !filteredStations.contains(where: { $0.site_id == station.site_id }){
                        filteredStations.append(station)
                        
                    }
                }
            }
        }
        print(filteredStations)
        
    }
    
}





