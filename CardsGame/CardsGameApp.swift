//
//  CardsGameApp.swift
//  CardsGame
//
//  Created by Islam Saadi on 18/05/2025.
//

import SwiftUI

@main
struct CardsGameApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            MainFlowView()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                SoundManager.shared.playBackgroundMusic()
            case .inactive, .background:
                SoundManager.shared.stopBackgroundMusic()
            default:
                break
            }
        }
    }
}
