//
//  GameOverView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
//

import SwiftUI

struct GameOverView: View {
    
    let playerName:  String
    let playerScore: Int
    let pcScore:     Int
    
    var onBackToMenu: () -> Void
    
    // Compute winner and winning score
    private var winnerName: String {
        playerScore > pcScore ? playerName : "PC"
    }
    private var winnerScore: Int {
        max(playerScore, pcScore)
    }

    var body: some View {
        VStack {
            Spacer()

            // Winner title
            Text("Winner: \(winnerName)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)

            // Winning score
            Text("score: \(winnerScore)")
                .font(.title)
                .padding(.top, 8)
                .foregroundColor(.primary)

            Spacer()

            // Back to menu button
            Button(action: {
                SoundManager.shared.stopEffectPlayer();
                onBackToMenu()
            }) {
                Text("BACK TO MENU")
                    .font(.headline)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Spacer(minLength: 40)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
