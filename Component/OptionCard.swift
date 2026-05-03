//
//  OptionCard.swift
//  Challenge1
//
//  Created by Saifulloh Rahman on 25/04/26.
//

import SwiftUI

struct OptionCard: View {
    let title: String
    let imageName: String

    private let cardWidth: CGFloat = 360
    private let cardHeight: CGFloat = 144

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.themeSecondary)
                .shadow(radius: 5)

            HStack {
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(.themePrimary)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 20)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.vertical, 20)

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 170, height: 115)
                .clipped()
                .padding(.trailing, 8)
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
