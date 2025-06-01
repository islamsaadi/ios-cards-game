//
//  Screen.swift
//  CardsGame
//
//  Created by Islam Saadi on 01/06/2025.
//

enum Screen {
    case welcome
    case game(playerName: String, isPlayerOnLeft: Bool)
    case gameOver(playerName: String, playerScore: Int, pcScore: Int)
}
