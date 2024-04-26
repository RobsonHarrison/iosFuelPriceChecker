//
//  PostcodeCheckerViewModel.swift
//  fuelPrices
//
//  Created by Matthew Paul Harding on 26/04/2024.
//

import Foundation

class PostcodeCheckerViewModel: ObservableObject {
    
    // properties for the UI View to "bind" to
    @Published var filteredStations: [PetrolStation] = []
    var postcode: String = ""
    var isRefreshing: Bool { // the ViewModel is the only API (interface) that should be visible to the View, so we wrap this value. i.e. we never want to write code where we are chaining down through the layers of architecture - ❌ viewModel.stationDataManager.isRefreshingData // ✅ viewModel.isRefreshingData
        stationDataManager.isRefreshingData
    }
    
    // access to "the system" (i.e. business logic layer)
    private var stationDataManager = StationDataManager(fuelProviders: FuelProviderDictionary.fuelProviders)
    
    func fetchData() {
        guard
        postcode.count >= 3, // business logic. This could be moved into stationDataManager.getStationData 🤔
        isRefreshing == false
        else {
            return
        }
        // In the SWIFTUI world we want the View to bind to the view model. And so, if one property changes value in this viewModel the View will automatically update. That's one of the purposes of the ViewModel - to let the View be dumb and only react when a simple value changes. In this function, we call the "system" to do something, we get the result and store it as "the list to be displayed".
        stationDataManager.getStationData(forPostcode: postcode) { result in
            switch result {
            case .success(let stations):
                self.filteredStations = stations // NOTE: Setting this value will trigger SwiftUI to refresh the screen
            case .failure(let error):
                break
                // TODO: What do you want to do in the event of an error?
                // clear the screen? Keep the existing results? Display a dialog or TOAST dialog to the user?
            }
        }
    }
}
