//
//  Card.swift
//  CardsGame
//
//  Created by Islam Saadi on 21/05/2025.
//
import SwiftUI

enum Suit: String, CaseIterable {
    case spades, diamonds
}

enum Rank: Int, CaseIterable {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack = 11, queen, king, ace = 14

    var label: String {
        switch self {
        case .jack:  return "J"
        case .queen: return "Q"
        case .king:  return "K"
        case .ace:   return "A"
        default:     return "\(self.rawValue)"
        }
    }
}

struct Card: Identifiable {
    let id = UUID()
    let suit: Suit
    let rank: Rank

    /// e.g. "spades_Q", "diamonds_10"
    var imageName: String {
        "\(suit.rawValue)_\(rank.label)"
    }

    /// Strength comparison (Ace high)
    var strength: Int { rank.rawValue }

    static func random() -> Card {
        Card(
            suit: Suit.allCases.randomElement()!,
            rank: Rank.allCases.randomElement()!
        )
    }
}
