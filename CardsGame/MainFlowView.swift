//
//  MainFlowView.swift
//  CardsGame
//
//  Created by Islam Saadi on 01/06/2025.
//

import SwiftUI
import CoreLocation

struct MainFlowView: View {
    @State private var currentScreen: Screen = .welcome

    var body: some View {
        switch currentScreen {
        case .welcome:
            WelcomeView(onStart: { name, isLeft in
                currentScreen = .game(playerName: name, isPlayerOnLeft: isLeft)
            })

        case .game(let playerName, let isPlayerOnLeft):
            GameView(
                onGameOver: { score1, score2 in
                    currentScreen = .gameOver(
                        playerName: playerName,
                        playerScore: score1,
                        pcScore: score2
                    )
                },
                playerName: playerName,
                isPlayerOnLeft: isPlayerOnLeft
            )

        case .gameOver(let playerName, let playerScore, let pcScore):
            GameOverView(
                playerName: playerName,
                playerScore: playerScore,
                pcScore: pcScore,
                onBackToMenu: {
                    currentScreen = .welcome
                }
            )
        }
    }
}
