//
//  StationDataAPInew.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation

class FuelStationDataAPI: ObservableObject {
    
    // MARK: - Response Errors
    
    enum FuelStationDataAPIError: Error {
        case noDataReceived
        case networkingError(Error)
        case jsonDecodingError(Error)
        case invalidURL
        case invalidResponse
        case timeout
        case unauthorized
        case forbidden
        case notFound
        case serverError
        case unknownError
    }
    
    // MARK: - Network Calls
    
    func requestFuelSupplierData(from url: URL, completion: @escaping (Result<FuelSupplierResponse, FuelStationDataAPIError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorTimedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.networkingError(error)))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    completion(.failure(.noDataReceived))
                    return
                }
                
                do {
                    let responseData = try JSONDecoder().decode(FuelSupplierResponse.self, from: data)
                    completion(.success(responseData))
                } catch {
                    completion(.failure(.jsonDecodingError(error)))
                }
                
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            case 500...599:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}
