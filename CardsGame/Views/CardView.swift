//
//  CardView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
import SwiftUI

struct CardView: View {
    let card: Card
    /// Angle passed down from GameView
    let flipAngle: Double

    /// Pick the right back image based on color scheme
    @Environment(\.colorScheme) private var colorScheme

    /// When the card is between 90° and 270° it’s “showing” its back
    private var isShowingBack: Bool {
        let normalized = flipAngle.truncatingRemainder(dividingBy: 360)
        return normalized >= 90 && normalized <= 270
    }

    var body: some View {
        Image(isShowingBack
              ? (colorScheme == .dark ? "back_dark" : "back_light")
              : card.imageName
        )
        .resizable()
        .aspectRatio(2/3, contentMode: .fit)
        .frame(width: 120, height: 180)
        // apply the 3D flip
        .rotation3DEffect(
            .degrees(flipAngle),
            axis: (x: 0, y: 1, z: 0)
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
        .shadow(radius: 4)
    }
}
