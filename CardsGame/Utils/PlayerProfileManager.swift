import Foundation

class PlayerProfileManager {
    static let shared = PlayerProfileManager()
    private let defaults = UserDefaults.standard

    private let playerNameKey = "playerName"

    private init() {}

    func savePlayerName(_ name: String) {
        defaults.set(name, forKey: playerNameKey)
    }

    func getPlayerName() -> String? {
        defaults.string(forKey: playerNameKey)
    }

    func saveScore(_ score: Int, for player: String) {
        defaults.set(score, forKey: scoreKey(for: player))
    }

    func getScore(for player: String) -> Int {
        defaults.integer(forKey: scoreKey(for: player))
    }

    private func scoreKey(for player: String) -> String {
        return "score_\(player)"
    }
}
