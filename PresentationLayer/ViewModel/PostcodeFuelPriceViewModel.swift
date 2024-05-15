//
//  PostcodeFuelPriceViewModel.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import Foundation

class PostcodeFuelPriceViewModel: ObservableObject {
    
    @Published var filteredFuelStation: [FuelStation] = []
    var filterPostcode: String = ""
    var isFetchingData: Bool {
        FuelStationDataManager.isFetchingData
    }
    
    private var FuelStationDataManager = FuelStationDataManager(fuelSuppliers: FuelSuppliers.supplierURLs)
    
    func fetchData() {
           guard
            filterPostcode.count >= 3, // business logic. This could be moved into stationDataManager.getStationData 🤔
            isFetchingData == false
           else {
               return
           }
        FuelStationDataManager.getStationData(forPostcode: filterPostcode) { result in
               switch result {
               case .success(let stations):
                   self.filteredStations = stations
               case .failure(let error):
                   break
                   // TODO: What do you want to do in the event of an error?
                   // clear the screen? Keep the existing results? Display a dialog or TOAST dialog to the user?
               }
           }
       }
   }
