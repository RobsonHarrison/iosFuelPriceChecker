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
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 255.0 / 255.0, green: 128.0 / 255.0, blue: 142.0 / 255.0))
                    .padding(.vertical)
                VStack {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.white)
                        .padding(.bottom)
                    Text(errorMessage)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .frame(height: getHeightForText(errorMessage))
        }
        .padding()
    }
}

func getHeightForText(_ text: String) -> CGFloat {
    let font = UIFont.systemFont(ofSize: 17)
    let attributedText = NSAttributedString(string: text, attributes: [.font: font])
    let constraintRect = CGSize(width: UIScreen.main.bounds.width - 32, height: .infinity)
    let boundingBox = attributedText.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
    return boundingBox.height + 100
}
