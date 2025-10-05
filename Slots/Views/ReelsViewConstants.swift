//
//  ReelsViewConstants.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

struct ReelsViewConstants {
    static let numberOfReels = 3
    static let numberOfSymbols = 50
    static let centerPosition = 26
    static let backgroundSizeMultiplier: CGFloat = 1.1
    static let containerSizeMultiplier: CGFloat = 0.9
    static let cornerRadiusMultiplier: CGFloat = 0.08
    static let containerRadiusMultiplier: CGFloat = 0.7
    static let containerPadding: CGFloat = 10
    static let shadowOffset = CGSize(width: 0, height: 2)
    static let shadowOpacity: Float = 0.3
    static let shadowRadius: CGFloat = 8
    static let borderWidth: CGFloat = 2
    static let cellBorderWidth: CGFloat = 1
    static let cellCornerRadius: CGFloat = 4
}

struct AnimationConstants {
    static let spinDuration: TimeInterval = 1.7
    static let slowDuration: TimeInterval = 0.3
    static let fastDuration: TimeInterval = 0.8
    static let slowDownDuration: TimeInterval = 0.1
    static let slowInterval: TimeInterval = 0.1
    static let fastInterval: TimeInterval = 0.1
    static let slowDownInterval: TimeInterval = 0.1
    static let stopDelayMultiplier: TimeInterval = 0.2
    static let lastReelExtraDuration: TimeInterval = 0.5
}
