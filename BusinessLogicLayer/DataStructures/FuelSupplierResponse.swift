//
//  FuelSupplierResponse.swift
//  fuelPrices
//
//  Created by Robson Harrison on 16/04/2024.
//

import Foundation

struct FuelSupplierResponse: Decodable {
    let last_updated: String
    let stations: [FuelStation]
}

struct FuelSupplierResponseDeocding: Decodable {
    let last_updated: String
    let stations: [FuelStationDeocding]
}
