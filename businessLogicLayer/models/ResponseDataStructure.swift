//
//  ResponseDataStructure.swift
//  fuelPrices
//
//  Created by Robson Harrison on 16/04/2024.
//

import Foundation

struct ResponseData: Decodable{
    let last_updated: String
    let stations: [StationData]
}
