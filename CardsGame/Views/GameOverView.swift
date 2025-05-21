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

    @Environment(\.dismiss) private var dismiss

    // Compute winner and winning score
    private var winnerName: String {
        playerScore >= pcScore ? playerName : "PC"
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

            // Winning score
            Text("score: \(winnerScore)")
                .font(.title)
                .padding(.top, 8)

            Spacer()

            // Back to menu button
            Button(action: {
                dismiss()
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

//import SwiftUI
//
//struct GameOverView: View {
//    let playerScore: Int
//    let pcScore:     Int
//
//    private var resultText: String {
//        if playerScore > pcScore {
//            return "🎉 You Win!"
//        } else if pcScore > playerScore {
//            return "💻 PC Wins!"
//        } else {
//            return "🏠 House Wins!"
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 24) {
//            Text("Game Over").font(.largeTitle).bold()
//            Text("Your Score: \(playerScore)")
//            Text("PC Score: \(pcScore)")
//            Text(resultText)
//                .font(.title2)
//                .padding(.top, 16)
//            Spacer()
//        }
//        .padding()
//        .navigationBarBackButtonHidden(true)
//    }
//}
