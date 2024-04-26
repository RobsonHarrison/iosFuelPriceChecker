//
//  StationDataManager.swift
//  fuelPrices
//
//  Created by Robson Harrison on 25/04/2024.
//

import Foundation

// The StationDataManager is the API (or interface) to this feature of the app. The caller of this class should not need any other knowledge of any internal workings of HOW this class achieves its purpose.
class StationDataManager: ObservableObject {
    
    enum StationDataManagerError: Error {
        case stationDataAPIError(StationDataAPI.StationDataAPIError)
        case refreshAlreadyInProgress
    }
    
    let fuelProviders: [String: String]
    private var dateOfLastRefresh: Date?
    private(set) var isRefreshingData = false
    // No layer above this class should know that StationDataAPI exists as a service.
    private var stationDataAPI = StationDataAPI()
    private var stationLibrary: [StationData] = []
    
    // MARK: - Constructor
    
    init(fuelProviders: [String: String]) {
        // a constructor (initialiser) should only initialize its properties. It shouldn't be used to trigger network calls or any other hidden behaviour.
        self.fuelProviders = fuelProviders
    }
    
    // MARK: - Publicly available functions / features (make it easy-to-use)
    
    func getStationData(forPostcode postcode: String, completion: @escaping (Result<[StationData], StationDataManagerError>) -> Void) {
        guard isRefreshingData == false else {
            // Note: ALWAYS call your completion handlers in 100% of scenarios 😉
            completion(.failure(.refreshAlreadyInProgress))
            return
        }
        isRefreshingData = true
        let endpointAddresses = fuelProviders.map{$1}
        gatherStationData(from: endpointAddresses) { result in
            DispatchQueue.main.async {
                self.isRefreshingData = false
                switch result {
                case .success(let stations):
                    self.dateOfLastRefresh = Date.now
                    // now that we are running back on the main thread we can set the array of stations to this instance of StationDataManager. But not before. Unless we use a queue to handle read and write access.
                    self.stationLibrary = stations // update the library of national petrol stations
                    let filteredResults = self.filterStations(stations, forPostcode: postcode)
                    completion(.success(filteredResults))
                case .failure(let error):
                    completion(result)
                }
            }
        }
    }
    
    // MARK: - Gathering data from StationDataAPI
    
    func gatherStationData(from endPointAddresses: [String], completion: @escaping (Result<[StationData], StationDataManagerError>) -> Void) {
        let stationDataAPI = self.stationDataAPI
        let dispatchGroup = DispatchGroup()
        var responses: [ResponseData] = []
        
        for (endPointAddress) in endPointAddresses {
            guard let url = URL(string: endPointAddress) else {
                print("Invalid URL for \(endPointAddress)")
                continue
            }
            
            dispatchGroup.enter()
            
            // let the API perform the network request. It shouldn't be aware of how to handle a list of urls. Instead, we simply make multiple calls using it. It's the role of that class to perform a network request and this class to loop through many urls. 😃
            // Also it know means that we could use the stationDataAPI to make one single call if we wanted it to - it's even more flexible now.
            stationDataAPI.requestStationData(from: url) { result in
                defer {
                    dispatchGroup.leave()
                }
                switch result {
                case .success(let response):
                    responses.append(response)
                case .failure(let error):
                    // TODO: handle this error, unless it's acceptable to ignore it.
                    break
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // TODO: We have not handled any of the errors passed to use from each network call.
            guard responses.count > 0 else { // This is a hacky approach to error handling :(
                completion(.failure(.refreshAlreadyInProgress))
                return
            }
            // amend the responses to provide a list of all found stations.
            let allStations: [StationData] = responses.flatMap{ $0.stations }
            
            // Remove duplicate stations from array. This is efficient because we only iterate through the array once and it's done at the time of reciving the data too
            var registeredSiteIDs: Set<String> = []
            let stationsWithoutDuplicates: [StationData] = allStations.compactMap { stationData in
                guard registeredSiteIDs.contains(stationData.site_id) == false else {
                    return nil // removes the duplicate from the array
                }
                registeredSiteIDs.insert(stationData.site_id)
                return stationData
            }
            completion(.success(stationsWithoutDuplicates))
        }
    }
    
    // MARK: - Filtering via postcode
    
    private func filterStations(_ stations: [StationData], forPostcode postcode: String) -> [StationData] {
        var filteredStations = [StationData]()
        for station in stations {
            if station.postcode.uppercased().hasPrefix(postcode.uppercased()) {
                filteredStations.append(station)
            }
        }
        return filteredStations
    }
}
