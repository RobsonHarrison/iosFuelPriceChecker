//
//  FuelStationDataAPI.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation

class FuelStationDataAPI: ObservableObject {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func requestFuelSupplierData(from url: URL, completion: @escaping (Result<FuelSupplierResponse, ErrorDefinitions.APIErrors>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            let urlString = url.absoluteString

            if let error = error {
                Logger.logNetworkError(ErrorDefinitions.APIErrors.networkingError(error).description, error: error, url: urlString)
                if (error as NSError).code == NSURLErrorTimedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.networkingError(error)))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.invalidResponse.description, url: urlString)
                completion(.failure(.invalidResponse))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    Logger.logNetworkInfo(ErrorDefinitions.APIErrors.noDataReceived.description, url: urlString)
                    completion(.failure(.noDataReceived))
                    return
                }

                do {
                    let responseDataDecoding = try JSONDecoder().decode(FuelSupplierResponseDeocding.self, from: data)

                    let validatedStations = responseDataDecoding.stations.compactMap { fuelStationDeocding in
                        if let site_id = fuelStationDeocding.site_id,
                           let brand = fuelStationDeocding.brand,
                           let address = fuelStationDeocding.address,
                           let postcode = fuelStationDeocding.postcode,
                           let location = fuelStationDeocding.location,
                           let prices = fuelStationDeocding.prices
                        {
                            return FuelStation(site_id: site_id, brand: brand, address: address, postcode: postcode, location: location, prices: prices)
                        }
                        return nil
                    }

                    let responseData = FuelSupplierResponse(last_updated: responseDataDecoding.last_updated, stations: validatedStations)

                    completion(.success(responseData))
                } catch {
                    Logger.logNetworkError(ErrorDefinitions.APIErrors.jsonDecodingError(error).description, error: error, url: urlString)
                    completion(.failure(.jsonDecodingError(error)))
                }

            case 401:
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.unauthorized.description, url: urlString)
                completion(.failure(.unauthorized))
            case 403:
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.forbidden.description, url: urlString)
                completion(.failure(.forbidden))
            case 404:
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.notFound.description, url: urlString)
                completion(.failure(.notFound))
            case 500 ... 599:
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.serverError.description, url: urlString)
                completion(.failure(.serverError))
            default:
                Logger.logNetworkInfo(ErrorDefinitions.APIErrors.unknownError.description, url: urlString)
                completion(.failure(.unknownError))
            }
        }
        task.resume()
    }
}
