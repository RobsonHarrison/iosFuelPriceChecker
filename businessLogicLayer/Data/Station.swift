//
//  StationDataStructure.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import Foundation

struct PetrolStation: Decodable, Hashable {
    let site_id: String
    let brand: String
    let address: String
    let postcode: String
    let location: StationLocation
    let prices: StationPrice
}
