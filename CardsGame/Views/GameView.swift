//
//  CardView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
import SwiftUI

struct GameView: View {
    // Configuration
    let playerName: String
    let isPlayerOnLeft: Bool

    // Game state
    @State private var playerScore  = 0
    @State private var pcScore      = 0
    @State private var roundCount   = 0
    private let maxRounds = 10

    @State private var timerValue             = 3
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var leftCard   = Card.random()
    @State private var rightCard  = Card.random()
    @State private var flipAngle  = 0.0

    @State private var gameEnded          = false
    @State private var navigateGameOver   = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ZStack {
                    Color.white.ignoresSafeArea()

                    VStack {
                        // Top Scores
                        HStack {
                            if isPlayerOnLeft {
                                ScoreView(name: playerName, score: playerScore)
                                Spacer()
                                ScoreView(name: "PC", score: pcScore)
                            } else {
                                ScoreView(name: "PC", score: pcScore)
                                Spacer()
                                ScoreView(name: playerName, score: playerScore)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, geo.safeAreaInsets.top + 16)

                        // Cards + Timer
                        HStack(spacing: 40) {
                            // Face or back is chosen inside CardView based on flipAngle
                            CardView(card: leftCard,  flipAngle: flipAngle)
                            TimerView(time: timerValue)
                            CardView(card: rightCard, flipAngle: flipAngle)
                        }
                        .padding(.top, 40)

                        Spacer()
                    }
                }
                .onReceive(timer) { _ in
                    guard !gameEnded else { return }
                    if timerValue > 0 {
                        timerValue -= 1
                    }
                    if timerValue == 0 {
                        playRound()
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigateGameOver) {
            GameOverView(
                playerName:    playerName,
                playerScore:   playerScore,
                pcScore:       pcScore
            )
        }
    }

    // Game Logic

    private func playRound() {
        // 1) Flip halfway
        withAnimation(.easeIn(duration: 0.2)) {
            flipAngle += 90
        }

        // 2) After half-flip, swap cards & update score
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let newLeft  = Card.random()
            let newRight = Card.random()
            leftCard  = newLeft
            rightCard = newRight

            if newLeft.strength > newRight.strength {
                playerScore += 1
            } else if newRight.strength > newLeft.strength {
                pcScore += 1
            }
            roundCount += 1

            // 3) Finish flip
            withAnimation(.easeOut(duration: 0.2)) {
                flipAngle += 90
            }

            // 4) Check for end
            if roundCount >= maxRounds {
                gameEnded        = true
                navigateGameOver = true
            } else {
                timerValue = 3
            }
        }
    }
}
