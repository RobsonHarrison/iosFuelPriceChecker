//
//  StationDataAPI.swift
//  fuelPrices
//
//  Created by Robson Harrison on 25/04/2024.
//

import Foundation

class StationDataAPI: ObservableObject {
    
    @Published var isDataFetched = false
    var responses: [FuelSupplierResponse] = []
    
    func getStationData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for (fuelProvider, jsonUrl) in FuelSuppliers.supplierURLs {
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
                    let responseData = try JSONDecoder().decode(FuelSupplierResponse.self, from: data)
                    responses.append(responseData)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
            self.isDataFetched = true
        }
    }
}
