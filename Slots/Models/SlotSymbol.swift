//
//  SlotSymbol.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import Foundation

enum SlotSymbol: String, CaseIterable {
    case cherry = "🍒"
    case star = "⭐️"
    case diamond = "💎"
    case seven = "7️⃣"
    
    var emoji: String {
        return self.rawValue
    }
}
