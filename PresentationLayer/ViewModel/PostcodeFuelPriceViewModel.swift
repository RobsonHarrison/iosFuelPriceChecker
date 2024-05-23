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
                   switch error {
                   case .userErrors(let userError):
                       self.errorMessage = userError.description
                   case .apiErrors(let apiError):
                       self.errorMessage = apiError.description
                   }
               }
           }
       }
   }
