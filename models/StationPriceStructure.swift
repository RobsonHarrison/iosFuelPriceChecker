//
//  StationPriceStructure.swift
//  fuelPrices
//
//  Created by Robson Harrison on 16/04/2024.
//

import Foundation

struct StationPrice: Decodable, Hashable{
    let E10: Decimal?
    let B7: Decimal?
    let E5: Decimal?
}
