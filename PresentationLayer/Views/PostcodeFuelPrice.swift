//
//  PostcodeFuel.swift
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
               
               Button("Search Prices") {
                   viewModel.fetchData() 
               }
               .buttonStyle(.bordered)
               .disabled(viewModel.isFetchingData)
               
               if viewModel.filteredFuelStation.count > 0 {
                   PriceListView(filteredStations: viewModel.filteredFuelStation)
                   MapView(filteredStations: viewModel.filteredFuelStation)
               }
           }
           .padding()
       }
   }

#Preview {
    PostcodeFuelPrice()
}
