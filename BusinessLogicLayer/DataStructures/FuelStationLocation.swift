//
//  FuelStationLocation.swift
//  fuelPrices
//
//  Created by Robson Harrison on 16/04/2024.
//

import Foundation

struct FuelStationLocation: Decodable, Hashable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try FuelStationLocation.decodeCoordinate(from: container, forKey: .latitude)
        longitude = try FuelStationLocation.decodeCoordinate(from: container, forKey: .longitude)
    }
    
    private static func decodeCoordinate(from container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Double {
        if let coordinate = try? container.decode(Double.self, forKey: key) {
            return coordinate
        } else if let coordinateString = try? container.decode(String.self, forKey: key), let coordinate = Double(coordinateString) {
            return coordinate
        } else {
            throw DecodingError.dataCorruptedError(forKey: key, in: container, debugDescription: "\(key.stringValue.capitalized) cannot be decoded")
        }
    }
}
