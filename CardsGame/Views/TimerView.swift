//
//  TimerView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
import SwiftUI

struct TimerView: View {
    let time: Int

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "timer").font(.system(size: 36))
            Text("\(time)")
                .font(.title)
                .monospacedDigit()
        }
        .foregroundColor(.primary)
    }
}
