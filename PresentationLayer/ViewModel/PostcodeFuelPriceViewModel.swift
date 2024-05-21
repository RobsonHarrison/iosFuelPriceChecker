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
    var filterPostcode: String = ""
    var isFetchingData: Bool {
        fuelStationDataManager.isFetchingData
    }
    
    private var fuelStationDataManager = FuelStationDataManager(supplierURLs: FuelSuppliers.supplierURLs)
    
    func fetchData() {
           guard
            isFetchingData == false
           else {
               return
           }
        

        fuelStationDataManager.getFuelStationData(forPostcode: filterPostcode) { result in
               switch result {
               case .success(let stations):
                   self.filteredFuelStation = stations

               case .failure(let error):
                let errorMessage = "Failed to fetch fuel station data: \(error)"
                Logger.logNetworkError(errorMessage, error: error, url: "")
               }
           }
       }
   }
