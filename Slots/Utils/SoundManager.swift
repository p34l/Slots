//
//  SoundManager.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    enum SoundType {
        case gameStart
        case lose
        case win
    }
    
    func playSound(_ soundType: SoundType) {
        let soundFileName: String
        
        switch soundType {
        case .gameStart:
            soundFileName = "game_sound"
        case .lose:
            soundFileName = "lose_sound"
        case .win:
            soundFileName = "win_sound"
        }
        
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else {
            print("Sound file not found: \(soundFileName).wav")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
