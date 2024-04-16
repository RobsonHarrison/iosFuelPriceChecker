//
//  fuelStructure.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import Foundation

class StationDataGetter {
        
    var stations: [Station] = []
        
    func getStationData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for (fuelProvider, jsonUrl) in fuelProviderDictionary.fuelProviders {
            guard let url = URL(string: jsonUrl) else {
                print("Invalid URL for \(fuelProvider): \(jsonUrl)")
                continue
            }

            dispatchGroup.enter()

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    dispatchGroup.leave()
                }

                guard let self = self else { return }

                if let error = error {
                    print("Error downloading data for \(fuelProvider) from \(url): \(error)")
                    return
                }
                guard let data = data else {
                    print("Error: No data received for \(fuelProvider) from \(url)")
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let stationsArray = json["stations"] as? [[String: Any]] else {
                        print("Error: Invalid JSON format or missing 'stations' key")
                        return
                    }

                    for stationData in stationsArray {
                        print(stationData)
                        if let station = self.parseStation(stationData) {
                            self.stations.append(station)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }
   
        dispatchGroup.notify(queue: .main) {
            completion()
            
            print("Stations Array:", self.stations)
        }
    }

    private func parseStation(_ stationData: [String: Any]) -> Station? {
            guard let brand = stationData["brand"] as? String,
                  let postcode = stationData["postcode"] as? String,
                  let locationDict = stationData["location"] as? [String: Any],
                  let longitude = locationDict["longitude"] as? Double,
                  let latitude = locationDict["latitude"] as? Double,
                  let pricesDict = stationData["prices"] as? [String: Any],
                  let e10 = pricesDict["E10"] as? Decimal,
                  let e5 = pricesDict["E5"] as? Decimal,
                  let b7 = pricesDict["B7"] as? Decimal else {
                print("Unable to construct station")
                return nil
            }
            
            print("Brand: \(brand), Postcode: \(postcode)") // Debug print
            
            let location = Location(postcode: postcode, longitude: longitude, latitude: latitude)
            let prices = Prices(e10: e10, b7: b7, e5: e5)
            return Station(brand: brand, location: location, prices: prices)
        }
}
