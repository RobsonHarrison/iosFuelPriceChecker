//
//  ContentView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/04/2024.
//

import SwiftUI

struct PostcodeCheckerView: View {
    
    // It's nice to name this variable "viewModel" as all developers will immeditely understand what it is used for!
    @ObservedObject private var viewModel = PostcodeCheckerViewModel()
    
    // It's nice how empty this view is and how little code exists for it. Afterall, its just the View and doesn't contain any business logic or "decisions" etc.
    var body: some View {
        VStack {
            
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()
            
            TextField("Enter the first part of your Postcode", text: $viewModel.postcode)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search Prices") {
                viewModel.fetchData() // This view is DUMB and only "knows" about the view model. It knows nothing else about the underlying system, which means it would be very easy to create a similar view specifically for the AppleWatch etc. 😃
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isRefreshing)
            
            if viewModel.filteredStations.count > 0 {
                PriceListView(filteredStations: viewModel.filteredStations)
                MapView(filteredStations: viewModel.filteredStations)
            }
        }
        .padding()
    }
}
