//
//  ErrorPromptView.swift
//  fuelPrices
//
//  Created by Robson Harrison on 23/05/2024.
//

import SwiftUI

struct ErrorPromptView: View {
    
    var errorMessage = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(red: 255.0/255.0, green: 128.0/255.0, blue: 142.0/255.0))
            Text(errorMessage)
                .foregroundColor(.white)
                .padding()
        }
    }
}
