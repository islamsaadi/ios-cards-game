//
//  GameView.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//

import SwiftUI

struct GameView: View {

    var onGameOver: (Int, Int) -> Void
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var isTimerActive = true
    @State private var showResumeMessage = false


    // Configuration
    let playerName: String
    let isPlayerOnLeft: Bool

    // Game state
    @State private var playerScore  = 0
    @State private var pcScore      = 0
    @State private var roundCount   = 0
    @State private var isBack = true
    @State private var isFlipping = false
    private let maxRounds = 10

    @State private var timerValue = 5
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var leftCard  = Card.random()
    @State private var rightCard = Card.random()
    @State private var flipAngle = 180.0

    @State private var gameEnded        = false
    @State private var navigateGameOver = false

    var body: some View {
        NavigationStack {
            GeometryReader { geo in

                ZStack(alignment: .top) {
                    Color(.systemBackground).ignoresSafeArea()

                    // Scores in top corners
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
                    .padding(.horizontal, 24)
                    .padding(.top, geo.safeAreaInsets.top + 16)

                    // Cards and Timer centered
                    VStack {
                        Spacer()
                        HStack(spacing: 40) {
                            CardView(card: leftCard, flipAngle: flipAngle)
                            TimerView(time: timerValue)
                            CardView(card: rightCard, flipAngle: flipAngle)
                        }
                        Spacer()
                    }
                }
                .onReceive(timer) { _ in
                    guard isTimerActive, !gameEnded, !isFlipping else { return }

                    if timerValue > 0 {
                        timerValue -= 1
                    }

                    if timerValue == 0 {
                        flipToFrontAndScore()
                    }
                }
                .overlay(
                    Group {
                        if showResumeMessage {
                            Text("Game Resumed")
                                .font(.headline)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .transition(.opacity)
                                .zIndex(1)
                        }
                    }
                )
                .onChange(of: scenePhase) {
                    if scenePhase == .background || scenePhase == .inactive {
                        isTimerActive = false
                    } else if scenePhase == .active {
                        isTimerActive = true
                        showResumeMessage = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showResumeMessage = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func flipToFrontAndScore() {
        isFlipping = true

        // Flip to front (reveal cards)
        withAnimation(.interpolatingSpring(stiffness: 200, damping: 18)) {
            flipAngle = 0
            SoundManager.shared.playFlipSound()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // Score current round
            if leftCard.strength > rightCard.strength {
                playerScore += 1
            } else if rightCard.strength > leftCard.strength {
                pcScore += 1
            }

            roundCount += 1

            // Wait 3 seconds to show the result
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Flip to back
                withAnimation(.easeInOut(duration: 0.4)) {
                    flipAngle = 180
                    SoundManager.shared.playFlipSound()
                }

                isBack = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    // End game or prepare next round
                    if roundCount >= maxRounds {
                        gameEnded = true
                        if(playerScore > pcScore) {
                            SoundManager.shared.playWinSound()
                        }else{
                            SoundManager.shared.playLoseSound()
                        }
                        onGameOver(playerScore, pcScore)
                    } else {
                        // Draw new cards
                        leftCard  = Card.random()
                        rightCard = Card.random()
                        flipAngle = 180  // keep back showing
                        timerValue = 5   // reset timer
                        isFlipping = false
                    }
                }
            }
        }
    }

}
