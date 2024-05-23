//
//  ErrorDefinitions.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/05/2024.
//

import Foundation

struct ErrorDefinitions {
    
    enum UserErrors: Error, CustomStringConvertible {
        case incorrectPostcode
        case noDataAvailable
        
        var description: String {
            switch self {
            case .incorrectPostcode:
                return "Postcode must be at least 3 characters long."
            case .noDataAvailable:
                return "Unable to retrieve information from fuel suppliers. Please try again later."
            }
        }
    }
    
    enum APIErrors: Error, CustomStringConvertible {
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
}
