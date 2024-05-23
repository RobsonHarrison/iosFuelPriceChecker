//
//  FuelStationDataManager.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation
import os.log

class FuelStationDataManager: ObservableObject {
    enum ErrorDefinition: Error {
        case userErrors(ErrorDefinitions.UserErrors)
        case apiErrors(ErrorDefinitions.APIErrors)
    }

    let fuelSuppliers: [String: String]
    private(set) var isFetchingData = false
    private var fuelStationDataAPI = FuelStationDataAPI()
    private var fuelStationLibrary: [FuelStation] = []

    // MARK: - Constructor

    init(supplierURLs: [String: String]) {
        fuelSuppliers = supplierURLs
    }

    // MARK: - Public Functions

    func getFuelStationData(forPostcode postcode: String, completion: @escaping (Result<[FuelStation], ErrorDefinition>) -> Void) {
        guard !isFetchingData else {
            Logger.logSystemError("API calls in progress already.", type: .info)
            completion(.failure(.userErrors(.dataFetchInProgress)))
            return
        }
        guard postcode.count >= 3 else {
            Logger.logSystemError("Invalid postcode length: \(postcode)", type: .error)
            completion(.failure(.userErrors(.incorrectPostcode)))
            return
        }
        isFetchingData = true
        let endpointURLs = fuelSuppliers.map { $1 }
        gatherFuelStationData(from: endpointURLs) { responses in
            DispatchQueue.main.async {
                self.isFetchingData = false
                var successfulResponses: [FuelSupplierResponse] = []
                var failedResponses: [String: ErrorDefinitions.APIErrors] = [:]

                for (url, response) in responses {
                    switch response {
                    case let .success(fuelSupplierResponse):
                        successfulResponses.append(fuelSupplierResponse)
                    case let .failure(error):
                        failedResponses[url] = error
                    }
                }

                guard failedResponses.count != endpointURLs.count else {
                    // TODO: Why did it fail
                    Logger.logSystemError("No fuel station API data recieved.", type: .error)
                    completion(.failure(.userErrors(.noDataAvailable)))
                    return
                }

                let allStations: [FuelStation] = successfulResponses.flatMap { $0.stations }
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
                if filteredResults.isEmpty {
                    Logger.logSystemError("No fuel stations found for postcode: \(postcode)", type: .info)
                    completion(.failure(.userErrors(.noPostcodeResults(postcode: postcode))))
                } else {
                    completion(.success(filteredResults))
                }
            }
        }
    }

    func gatherFuelStationData(from endpointURLs: [String], completion: @escaping ([String: Result<FuelSupplierResponse, ErrorDefinitions.APIErrors>]) -> Void) {
        let fuelStationDataAPI = self.fuelStationDataAPI
        let dispatchGroup = DispatchGroup()
        var responses: [String: Result<FuelSupplierResponse, ErrorDefinitions.APIErrors>] = [:]

        for endpointURL in endpointURLs {
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

    // MARK: - Filtering via postcode

    private func filterStations(_ stations: [FuelStation], forPostcode postcode: String) -> [FuelStation] {
        let filteredStations = stations.filter { $0.postcode.uppercased().hasPrefix(postcode.uppercased()) }
        return filteredStations
    }
}
