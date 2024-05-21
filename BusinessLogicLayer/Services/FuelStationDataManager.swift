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
        case fuelStationDataAPIError (FuelStationDataAPI.FuelStationDataAPIError)
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
        guard isFetchingData == false,
        postcode.count >= 3 else {
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
                    let errorMessage = "Failed to fetch fuel station data: \(error)"
                    Logger.logNetworkError(errorMessage, error: error)
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
           let filteredStations = stations.filter { $0.postcode.uppercased().hasPrefix(postcode.uppercased()) }
                   
                   if filteredStations.isEmpty {
                       Logger.logNetworkInfo("No fuel stations found for postcode: \(postcode)")
                   }
                   
                   return filteredStations
       }
    
    
    
    
}
    
    

