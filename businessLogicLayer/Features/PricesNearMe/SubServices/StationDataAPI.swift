//
//  StationDataAPI.swift
//  fuelPrices
//
//  Created by Robson Harrison on 25/04/2024.
//

import Foundation

class StationDataAPI: ObservableObject {
    
    // MARK: - Error Codes
    
    enum StationDataAPIError: Error {
        case noDataRecieved
        case networkingError(Error)
        case jsonDecodingError
    }
    
    // MARK: - Network Calls
    
    func requestStationData(from url: URL, completion: @escaping (Result<ResponseData, StationDataAPIError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading data from \(url): \(error)")
                completion(.failure(.networkingError(error)))
                return
            }
            guard let data = data else {
                print("Error: No data received from \(url)")
                completion(.failure(.noDataRecieved))
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                completion(.success(responseData))
            } catch {
                print("Error parsing JSON: \(error)")
                completion(.failure(.jsonDecodingError))
            }
        }
        task.resume()
    }
}
