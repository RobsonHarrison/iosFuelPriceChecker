//
//  PostcodeFuelPriceViewModel.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation
import os.log

class PostcodeFuelPriceViewModel: ObservableObject {
    @Published var filteredFuelStation: [FuelStation] = []
    @Published var errorMessage: String? = nil

    var filterPostcode: String = ""
    var isFetchingData: Bool {
        fuelStationDataManager.isFetchingData
    }

    private var fuelStationDataManager = FuelStationDataManager(supplierURLs: FuelSuppliers.supplierURLs)

    func fetchData() {
        fuelStationDataManager.getFuelStationData(forPostcode: filterPostcode) { result in
            switch result {
            case let .success(stations):
                self.filteredFuelStation = stations

            case let .failure(error):
                self.filteredFuelStation = []
                switch error {
                case let .userErrors(userError):
                    self.errorMessage = userError.description
                case let .apiErrors(apiError):
                    self.errorMessage = apiError.description
                }
            }
        }
    }
}
