# 🃏 iOS Card Game App

A fun and interactive card-flipping game built using **Swift 6** and **SwiftUI**, featuring location-based side assignment, animations, scoring, and full support for dark mode and iOS lifecycle handling.

## 📱 App Overview

This is a two-player card game (Player vs PC) where:

- The user enters their name and location is determined.
- Based on the longitude, the player is assigned to **East Side** or **West Side**.
- The game starts automatically: both cards flip every 5 seconds.
- The stronger card scores a point for its player.
- After 10 rounds, the winner is announced.
- Supports **light and dark mode**, and handles app lifecycle correctly.

## ✨ Features

- ✅ Swift 6 & SwiftUI-based UI
- 📍 Location-based side selection (east/west of longitude `34.817549168324334`)
- 🌓 Dark Mode Support
- 🎯 Auto gameplay (every 5 seconds)
- 📈 Scores
- 🔁 Lifecycle awareness (pause/resume game properly)
- 🎨 Animated UI with flipping cards
- 🧭 Orientation support (portrait & landscape)

## 🗺️ Screenshots

| Welcome Screen             | Game Screen                | Game Over Screen          |
|---------------------------|----------------------------|---------------------------|
| ![Welcome](screenshots/welcome-light.png) | ![Game](screenshots/game-light.png) ![Game](screenshots/game2-light.png) | ![Game Over](screenshots/gameover-light.png) |
| ![Welcome Dark](screenshots/welcome-dark.png) | ![Game Dark](screenshots/game-dark.png) ![Game Dark](screenshots/game2-dark.png) | ![Game Over Dark](screenshots/gameover-dark.png) |

## 🛠 Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/ios-card-game.git
   cd ios-card-game
   ```

2. Open `CardsGame.xcodeproj` in **Xcode 15+**

3. Make sure to:
   - Run on a real device or set a mock location in the simulator.
   - Add the following to your `Info.plist` for location access:

     ```xml
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>We use your location to determine your side in the game.</string>
     ```

4. Build and run the app 🎉

## 🎮 How to Play

1. Open the app.
2. Insert your name when prompted (only the first time).
3. Location is fetched to determine your side (East/West).
4. The game starts automatically:
   - Each turn lasts 5 seconds.
   - Cards flip and points are awarded.
5. After 10 turns, a summary screen announces the winner.
6. Tap "Back to Menu" to return.

## 🧪 Lifecycle & UX

- Location is fetched once per app open.
- Gameplay is paused when the app moves to background and resumed correctly.
- Clean NavigationStack used for managing screens.
- App works smoothly in both portrait and landscape modes.

## 🌓 Dark Mode

- Text and images change accordingly.
- Fully supported across all views.

## 📜 License

MIT License.

