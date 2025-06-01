//
//  ScoreView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
import SwiftUI

struct ScoreView: View {
    let name: String
    let score: Int

    var body: some View {
        VStack(spacing: 4) {
            Text(name).font(.headline)
            Text("\(score)").font(.system(size: 40, weight: .bold))
        }
        .foregroundColor(.primary)
    }
}
