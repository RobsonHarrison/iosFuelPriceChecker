//
//  StationDataManagerNew.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation
import os.log

class FuelStationDataManager: ObservableObject {
    
//    enum FuelStationDataAPIError: Error {
//        case fuelStationDataAPIError (FuelStationDataAPI.FuelStationDataAPIError)
//        case dataFetchAlreadyInProgress
//    }
    
    enum ErrorDefinition: Error {
        case userErrors (ErrorDefinitions.UserErrors)
        case apiErrors (ErrorDefinitions.APIErrors)
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
    
    func getFuelStationData(forPostcode postcode: String, completion: @escaping (Result<[FuelStation], ErrorDefinition>) -> Void) {
        guard isFetchingData == false,
        postcode.count >= 3 else {
            completion(.failure(.userErrors(.incorrectPostcode)))
            return
        }
        isFetchingData = true
        let endpointURLs = fuelSuppliers.map{$1}
        gatherFuelStationData(from: endpointURLs) { responses in
            DispatchQueue.main.async {
                self.isFetchingData = false
//                 TODO: Did all responses fail, why? Call completion imedietly
//                 TODO: Are we operating with restricted data set, why?
//                 TODO: Are all responses successful?
//                 TODO: Handle duplicates
                
                var successfulResponses: [FuelSupplierResponse] = []
                var failedResponses: [String:ErrorDefinitions.APIErrors] = [:]
                
                for (url, response) in responses {
                    switch response {
                    case .success(let fuelSupplierResponse):
                        successfulResponses.append(fuelSupplierResponse)
                    case .failure(let error):
                        failedResponses[url] = error
                        break
                    }
                }
                
                guard successfulResponses.count > 0 else {
                 // TODO: Why did it fail
                    completion(.failure(.userErrors(.noDataAvailable))) // TODO: Create correct failures
                    return
                }
                
//                Remove duplicates
                let allStations: [FuelStation] = successfulResponses.flatMap{ $0.stations }
                var registeredSiteIDs: Set<String> = []
                let stationsWithoutDuplicates: [FuelStation] = allStations.compactMap { stationData in
                    guard registeredSiteIDs.contains(stationData.site_id) == false else {
                        return nil
                    }
                    registeredSiteIDs.insert(stationData.site_id)
                    return stationData
                }
                self.fuelStationLibrary = stationsWithoutDuplicates
                let filteredResults = self.filterStations(stationsWithoutDuplicates, forPostcode: postcode)
                completion(.success(filteredResults))
            }
        }
    }
    
    func gatherFuelStationData(from endpointURLs: [String], completion: @escaping ([String: Result<FuelSupplierResponse, ErrorDefinitions.APIErrors>]) -> Void) {
        let fuelStationDataAPI = self.fuelStationDataAPI
        let dispatchGroup = DispatchGroup()
        var responses: [String: Result<FuelSupplierResponse, ErrorDefinitions.APIErrors>] = [:]
        
        for (endpointURL) in endpointURLs {
            guard let url = URL(string: endpointURL) else {
                continue
            }
           
            dispatchGroup.enter()
        
            fuelStationDataAPI.requestFuelSupplierData(from: url) { result in
                defer {
                    dispatchGroup.leave()
                }
                responses[endpointURL] = result
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(responses)
        }
    }
    
//    func gatherFuelStationData(from endpointURLs: [String], completion: @escaping (Result<[FuelStation], FuelStationDataAPIError>) -> Void) {
//        let fuelStationDataAPI = self.fuelStationDataAPI
//        let dispatchGroup = DispatchGroup()
//        var responses: [FuelSupplierResponse] = []
//        var errorResponseCount = 0
//        
//        for (endpointURL) in endpointURLs {
//            guard let url = URL(string: endpointURL) else {
//                continue
//            }
//            
//            dispatchGroup.enter()
//        
//            fuelStationDataAPI.requestFuelSupplierData(from: url) { result in
//                defer {
//                    dispatchGroup.leave()
//                }
//                switch result {
//                case .success(let response):
//                    responses.append(response)
//                case .failure(_):
//                    errorResponseCount += 1
////                    MODAL POPUP FOR USER NOTIFICATION.
//                    break
//                }
//            }
//        }
//        
//        dispatchGroup.notify(queue: .main) {
//            // TODO: We have not handled any of the errors passed to use from each network call.
//            guard errorResponseCount != endpointURLs.count else {
////                TODO: Why did it fail? e.g. phone connectivity issues. 404 for all URLs
//                completion(.failure(.dataFetchAlreadyInProgress))
//                return
//            }
//            
////            TODO: Indivdual failures, why? Operating with restricted data, more info screen listing details.
//         
//            let allStations: [FuelStation] = responses.flatMap{ $0.stations }
//            
//            var registeredSiteIDs: Set<String> = []
//            let stationsWithoutDuplicates: [FuelStation] = allStations.compactMap { stationData in
//                guard registeredSiteIDs.contains(stationData.site_id) == false else {
//                    return nil
//                }
//                registeredSiteIDs.insert(stationData.site_id)
//                return stationData
//            }
//            completion(.success(stationsWithoutDuplicates))
//        }
//    }
    
    // MARK: - Filtering via postcode
       
       private func filterStations(_ stations: [FuelStation], forPostcode postcode: String) -> [FuelStation] {
           let filteredStations = stations.filter { $0.postcode.uppercased().hasPrefix(postcode.uppercased()) }
                   
                   if filteredStations.isEmpty {
                       Logger.logSystemError("No fuel stations found for postcode: \(postcode)", type: .info)
                   }
                   
                   return filteredStations
       }
    
    
    
    
}
    
    

