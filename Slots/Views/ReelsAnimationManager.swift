//
//  ReelsAnimationManager.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class ReelsAnimationManager {
    private var reels: [UICollectionView]
    private weak var reelsView: ReelsView?

    init(reels: [UICollectionView], reelsView: ReelsView) {
        self.reels = reels
        self.reelsView = reelsView
    }

    func spinReels(to symbols: [SlotSymbol], completion: @escaping () -> Void) {
        var completedReels = 0

        for (index, symbol) in symbols.enumerated() {
            guard index < reels.count else { continue }

            let stopDelay = Double(index) * AnimationConstants.stopDelayMultiplier
            let isLastReel = index == ReelsViewConstants.numberOfReels - 1
            let duration = isLastReel ?
                AnimationConstants.spinDuration + AnimationConstants.lastReelExtraDuration :
                AnimationConstants.spinDuration

            animateReelWithFallingSymbols(
                reel: reels[index],
                targetSymbol: symbol,
                duration: duration,
                stopDelay: stopDelay
            ) {
                completedReels += 1
                if completedReels == self.reels.count {
                    completion()
                }
            }
        }
    }

    private func animateReelWithFallingSymbols(
        reel: UICollectionView,
        targetSymbol: SlotSymbol,
        duration: TimeInterval,
        stopDelay: TimeInterval = 0,
        completion: @escaping () -> Void
    ) {
        let reelIndex = reel.tag
        setupInitialAnimationState(for: reel, at: reelIndex)

        startSlowPhase(reel: reel, reelIndex: reelIndex, stopDelay: stopDelay, targetSymbol: targetSymbol, duration: duration, completion: completion)
    }

    private func setupInitialAnimationState(for reel: UICollectionView, at reelIndex: Int) {
        let newSymbols = generateRandomSymbols()
        reelsView?.updateReelData(at: reelIndex, symbols: newSymbols)
        reel.reloadData()

        let cellHeight = reel.frame.height
        let startOffset = CGFloat(ReelsViewConstants.centerPosition) * cellHeight
        reel.contentOffset.y = startOffset
    }

    private func startSlowPhase(
        reel: UICollectionView,
        reelIndex: Int,
        stopDelay: TimeInterval,
        targetSymbol: SlotSymbol,
        duration: TimeInterval,
        completion: @escaping () -> Void
    ) {
        var slowCounter = 0
        let slowSteps = Int(AnimationConstants.slowDuration / AnimationConstants.slowInterval)

        Timer.scheduledTimer(withTimeInterval: AnimationConstants.slowInterval, repeats: true) { timer in
            slowCounter += 1
            self.updateRandomSymbols(reelIndex: reelIndex, excludeTarget: true)
            reel.reloadData()

            if slowCounter >= slowSteps {
                timer.invalidate()
                self.startFastPhase(reel: reel, reelIndex: reelIndex, stopDelay: stopDelay, targetSymbol: targetSymbol, duration: duration, completion: completion)
            }
        }
    }

    private func startFastPhase(
        reel: UICollectionView,
        reelIndex: Int,
        stopDelay: TimeInterval,
        targetSymbol: SlotSymbol,
        duration: TimeInterval,
        completion: @escaping () -> Void
    ) {
        var fastCounter = 0
        let fastSteps = Int(AnimationConstants.fastDuration / AnimationConstants.fastInterval)

        Timer.scheduledTimer(withTimeInterval: AnimationConstants.fastInterval, repeats: true) { timer in
            fastCounter += 1
            self.updateRandomSymbols(reelIndex: reelIndex, excludeTarget: true)
            reel.reloadData()

            if fastCounter >= fastSteps {
                timer.invalidate()
                self.startSlowDownPhase(reel: reel, reelIndex: reelIndex, stopDelay: stopDelay, targetSymbol: targetSymbol, completion: completion)
            }
        }
    }

    private func startSlowDownPhase(
        reel: UICollectionView,
        reelIndex: Int,
        stopDelay: TimeInterval,
        targetSymbol: SlotSymbol,
        completion: @escaping () -> Void
    ) {
        var slowDownCounter = 0
        let slowDownSteps = Int(AnimationConstants.slowDownDuration / AnimationConstants.slowDownInterval)

        Timer.scheduledTimer(withTimeInterval: AnimationConstants.slowDownInterval, repeats: true) { timer in
            slowDownCounter += 1
            self.updateRandomSymbols(reelIndex: reelIndex, excludeTarget: true)
            reel.reloadData()

            if slowDownCounter >= slowDownSteps {
                timer.invalidate()
                self.finishAnimation(reel: reel, reelIndex: reelIndex, stopDelay: stopDelay, targetSymbol: targetSymbol, completion: completion)
            }
        }
    }

    private func finishAnimation(
        reel: UICollectionView,
        reelIndex: Int,
        stopDelay: TimeInterval,
        targetSymbol: SlotSymbol,
        completion: @escaping () -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + stopDelay) {
            guard let currentSymbols = self.reelsView?.getReelData(for: reelIndex) else { return }
            var newSymbols = currentSymbols
            newSymbols[ReelsViewConstants.centerPosition] = targetSymbol
            self.reelsView?.updateReelData(at: reelIndex, symbols: newSymbols)
            reel.reloadData()
            completion()
        }
    }

    private func updateRandomSymbols(reelIndex: Int, excludeTarget: Bool) {
        guard let currentSymbols = reelsView?.getReelData(for: reelIndex) else { return }
        var newSymbols = currentSymbols

        for i in 0 ..< ReelsViewConstants.numberOfSymbols {
            if !excludeTarget || i != ReelsViewConstants.centerPosition - 1 {
                newSymbols[i] = SlotSymbol.allCases.randomElement() ?? .cherry
            }
        }

        reelsView?.updateReelData(at: reelIndex, symbols: newSymbols)
    }

    private func generateRandomSymbols() -> [SlotSymbol] {
        return (0 ..< ReelsViewConstants.numberOfSymbols).map { _ in
            SlotSymbol.allCases.randomElement() ?? .cherry
        }
    }
}
