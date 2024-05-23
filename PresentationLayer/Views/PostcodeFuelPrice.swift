//
//  PostcodeFuelPrice.swift
//  fuelPrices
//
//  Created by Robson Harrison on 15/05/2024.
//

import SwiftUI

struct PostcodeFuelPrice: View {
    @ObservedObject private var viewModel = PostcodeFuelPriceViewModel()

    var body: some View {
        VStack {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .padding()

            TextField("Enter the first part of your Postcode", text: $viewModel.filterPostcode)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(.allCharacters)

            Button("Search Prices") {
                viewModel.fetchData()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 1.0 / 255.0, green: 127.0 / 255.0, blue: 113.0 / 255.0))
            .disabled(viewModel.isFetchingData)

            if viewModel.filteredFuelStation.count > 0 {
                PriceListView(filteredStations: viewModel.filteredFuelStation)
                MapView(filteredStations: viewModel.filteredFuelStation)
            } else if let errorMessage = viewModel.errorMessage {
                ErrorPromptView(errorMessage: errorMessage)
            }
        }
        .padding()
    }
}

#Preview {
    PostcodeFuelPrice()
}
