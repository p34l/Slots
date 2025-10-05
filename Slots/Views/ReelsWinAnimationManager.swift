//
//  ReelsWinAnimationManager.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class ReelsWinAnimationManager {
    
    // MARK: - Properties
    private weak var containerView: UIView?
    private var reels: [UICollectionView]
    
    // MARK: - Initialization
    init(containerView: UIView, reels: [UICollectionView]) {
        self.containerView = containerView
        self.reels = reels
    }
    
    // MARK: - Public Methods
    func startWinAnimation() {
        startPulsationAnimation()
        startReelBlinkingAnimation()
    }
    
    // MARK: - Private Animation Methods
    private func startPulsationAnimation() {
        guard let containerView = containerView else { return }
        
        // Пульсація всього контейнера
        UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse], animations: {
            containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            containerView.transform = .identity
        }
        
        // Зупиняємо пульсацію через 0.5 секунди
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            containerView.layer.removeAllAnimations()
            containerView.transform = .identity
        }
    }
    
    private func startReelBlinkingAnimation() {
        // Миготіння барабанів
        for reel in reels {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse], animations: {
                reel.alpha = 0.3
            }) { _ in
                reel.alpha = 1.0
            }
        }
        
        // Зупиняємо миготіння через 0.5 секунди
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for reel in self.reels {
                reel.layer.removeAllAnimations()
                reel.alpha = 1.0
            }
        }
    }
}
