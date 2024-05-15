//
//  StationDataManagerNew.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation
import os.log

class FuelStationDataManager: ObservableObject {
    
    enum FuelStationDataAPIError: Error {
        case FuelStationDataAPIError (FuelStationDataAPI.FuelStationDataAPIError)
        case dataFetchAlreadyInProgress
    }
    
    let fuelSuppliers: [String: String]
    private(set) var isFetchingData = false
    private var fuelStationDataAPI = FuelStationDataAPI()
    private var fuelStationLibrary: [FuelStation] = []
    
    // MARK: - Constructor
    
    init(supplierURLs: [String: String]) {
        self.fuelSuppliers = supplierURLs
    }
    
    // MARK: - Public Functions
    
    func getFuelStationData(forPostcode postcode: String, completion: @escaping (Result<[FuelStation], FuelStationDataAPIError>) -> Void) {
        guard isFetchingData == false else {
            completion(.failure(.dataFetchAlreadyInProgress))
            return
        }
        isFetchingData = true
        let endpointURLs = fuelSuppliers.map{$1}
        gatherFuelStationData(from: endpointURLs) { result in
            DispatchQueue.main.async {
                self.isFetchingData = false
                switch result {
                case .success(let stations):
                    self.fuelStationLibrary = stations
                    let filteredResults = self.filterStations(stations, forPostcode: postcode)
                    completion(.success(filteredResults))
                case .failure(let error):
                    completion(result)
                }
            }
        }
    }
    
    func gatherFuelStationData(from endpointURLs: [String], completion: @escaping (Result<[FuelStation], FuelStationDataAPIError>) -> Void) {
        let fuelStationDataAPI = self.fuelStationDataAPI
        let dispatchGroup = DispatchGroup()
        var responses: [FuelSupplierResponse] = []
        var errorResponseCount = 0
        
        for (endpointURL) in endpointURLs {
            guard let url = URL(string: endpointURL) else {
                os_log("Invalid URL for %@", log: .default, type: .error, endpointURL)
                continue
            }
            
            dispatchGroup.enter()
        
            fuelStationDataAPI.requestFuelSupplierData(from: url) { result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success(let response):
                    responses.append(response)
                case .failure(let error):
                    let errorDescription = "\(url) - \(error)"
                    os_log("Error fetching data: %@", log: .default, type: .error, errorDescription)
                    errorResponseCount += 1
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // TODO: We have not handled any of the errors passed to use from each network call.
            guard errorResponseCount != endpointURLs.count else {
                completion(.failure(.dataFetchAlreadyInProgress))
                return
            }
         
            let allStations: [FuelStation] = responses.flatMap{ $0.stations }
            
            var registeredSiteIDs: Set<String> = []
            let stationsWithoutDuplicates: [FuelStation] = allStations.compactMap { stationData in
                guard registeredSiteIDs.contains(stationData.site_id) == false else {
                    return nil
                }
                registeredSiteIDs.insert(stationData.site_id)
                return stationData
            }
            completion(.success(stationsWithoutDuplicates))
        }
    }
    
    // MARK: - Filtering via postcode
       
       private func filterStations(_ stations: [FuelStation], forPostcode postcode: String) -> [FuelStation] {
           var filteredStations = [FuelStation]()
           for station in stations {
               if station.postcode.uppercased().hasPrefix(postcode.uppercased()) {
                   filteredStations.append(station)
               }
           }
           return filteredStations
       }
    
    
    
    
}
    
    

