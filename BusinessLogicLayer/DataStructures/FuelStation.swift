//
//  FuelStation.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import Foundation

struct FuelStation: Decodable, Hashable{
    let site_id: String
    let brand: String
    let address: String
    let postcode: String
    let location: FuelStationLocation
    let prices: FuelStationPrice
}





