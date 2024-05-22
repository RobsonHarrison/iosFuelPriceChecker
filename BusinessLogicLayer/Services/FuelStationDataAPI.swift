//
//  StationDataAPInew.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation

class FuelStationDataAPI: ObservableObject {
    
    // MARK: - Response Errors
    
    enum FuelStationDataAPIError: Error, CustomStringConvertible {
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
           
           var description: String {
               switch self {
               case .noDataReceived:
                   return "No data received from the server."
               case .networkingError(let error):
                   return "Networking error occurred: \(error.localizedDescription)"
               case .jsonDecodingError(let error):
                   return "Failed to decode JSON response: \(error.localizedDescription)"
               case .invalidURL:
                   return "Invalid URL provided."
               case .invalidResponse:
                   return "Invalid response received from the server."
               case .timeout:
                   return "The request timed out."
               case .unauthorized:
                   return "Unauthorized request."
               case .forbidden:
                   return "Forbidden request."
               case .notFound:
                   return "Resource not found."
               case .serverError:
                   return "Server encountered an error."
               case .unknownError:
                   return "An unknown error occurred."
               }
           }
       }
    
    // MARK: - Network Calls
    
    func requestFuelSupplierData(from url: URL, completion: @escaping (Result<FuelSupplierResponse, FuelStationDataAPIError>) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                let urlString = url.absoluteString
                
                if let error = error {
//                    Logger.logNetworkError("Network error occurred", error: error, url: urlString)
                    if (error as NSError).code == NSURLErrorTimedOut {
                        completion(.failure(.timeout))
                    } else {
                        completion(.failure(.networkingError(error)))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
//                    Logger.logNetworkInfo("Invalid response received", url: urlString)
                    completion(.failure(.invalidResponse))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    guard let data = data else {
//                        Logger.logNetworkInfo("No data received from server", url: urlString)
                        completion(.failure(.noDataReceived))
                        return
                    }
                    
                    do {
                        let responseData = try JSONDecoder().decode(FuelSupplierResponse.self, from: data)
                        completion(.success(responseData))
                    } catch {
//                        Logger.logNetworkError("JSON decoding error", error: error, url: urlString)
                        completion(.failure(.jsonDecodingError(error)))
                    }
                    
                case 401:
//                    Logger.logNetworkInfo("Unauthorized access (401)", url: urlString)
                    completion(.failure(.unauthorized))
                case 403:
//                    Logger.logNetworkInfo("Forbidden access (403)", url: urlString)
                    completion(.failure(.forbidden))
                case 404:
                    completion(.failure(.notFound))
                case 500...599:
//                    Logger.logNetworkInfo("Server error occurred (\(httpResponse.statusCode))", url: urlString)
                    completion(.failure(.serverError))
                default:
//                    Logger.logNetworkInfo("Unknown error occurred (\(httpResponse.statusCode))", url: urlString)
                    completion(.failure(.unknownError))
                }
            }
            task.resume()
        }
    }
