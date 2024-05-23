//
//  ErrorDefinitions.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/05/2024.
//

import Foundation

enum ErrorDefinitions {
    enum UserErrors: Error, CustomStringConvertible {
        case incorrectPostcode
        case noPostcodeResults
        case noDataAvailable
        case dataFetchInProgress

        var description: String {
            switch self {
            case .incorrectPostcode:
                return "Postcode must be at least 3 characters long."
            case .noPostcodeResults:
                return "No fuel stations found for your postcode."
            case .noDataAvailable:
                return "Unable to retrieve information from fuel suppliers. Please try again later."
            case .dataFetchInProgress:
                return "A postcode search is already in progress. Please wait for results."
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
            case let .networkingError(error):
                return "Networking error occurred: \(error.localizedDescription)"
            case let .jsonDecodingError(error):
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
