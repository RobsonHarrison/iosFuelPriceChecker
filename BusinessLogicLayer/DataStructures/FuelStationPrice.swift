//
//  FuelStationPrice.swift
//  fuelPrices
//
//  Created by Robson Harrison on 16/04/2024.
//

import Foundation

struct FuelStationPrice: Decodable, Hashable {
    let E10: Decimal?
    let B7: Decimal?
    let E5: Decimal?
    let SDV: Decimal?

    private func formattedString(for value: Decimal?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return value.flatMap { formatter.string(for: $0) }
    }

    var formattedE10: String? {
        return formattedString(for: E10)
    }

    var formattedB7: String? {
        return formattedString(for: B7)
    }

    var formattedE5: String? {
        return formattedString(for: E5)
    }

    var formattedSDV: String? {
        return formattedString(for: SDV)
    }
}
