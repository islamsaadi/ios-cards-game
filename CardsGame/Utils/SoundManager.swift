//
//  SoundManager.swift
//  CardsGame
//
//  Created by Islam Saadi on 03/06/2025.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var backgroundPlayer: AVAudioPlayer?
    private var effectPlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func playBackgroundMusic() {
        // Don't restart if already playing
        guard backgroundPlayer?.isPlaying != true else { return }
        play(&backgroundPlayer, fileName: "background", loops: -1, volume: 0.4)
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
    }

    func playFlipSound() {
        play(&effectPlayer, fileName: "flip-card", loops: 0, volume: 3.0)
    }

    func playWinSound() {
        play(&effectPlayer, fileName: "winner", loops: 0, volume: 1.0)
    }

    func playLoseSound() {
        play(&effectPlayer, fileName: "game-over", loops: 0, volume: 1.0)
    }

    private func play(_ player: inout AVAudioPlayer?, fileName: String, loops: Int, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") ??
                       Bundle.main.url(forResource: fileName, withExtension: "wav") else {
            print("Sound file \(fileName) not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loops
            player?.volume = volume
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
