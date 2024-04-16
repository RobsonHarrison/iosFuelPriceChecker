//
//  fuelStructure.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import Foundation

struct Station{
    var brand: String
    var location: Location
    var prices: Prices
}

struct Prices{
    var e10: Decimal
    var b7: Decimal
    var e5: Decimal
}

struct Location{
    var postcode: String
    var longitude: Double
    var latitude: Double
}
