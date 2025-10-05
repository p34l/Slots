//
//  GameResult.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

struct GameResult {
    let symbols: [SlotSymbol]
    let isWin: Bool
    let pointsChange: Int
    let message: String

    init(symbols: [SlotSymbol]) {
        self.symbols = symbols

        let isWin = symbols.count == 3 && symbols[0] == symbols[1] && symbols[1] == symbols[2]
        self.isWin = isWin

        pointsChange = isWin ? 100 : -10

        message = isWin ? "Перемога!" : "Не пощастило!"
    }

    init(symbols: [SlotSymbol], isWin: Bool, pointsChange: Int, message: String) {
        self.symbols = symbols
        self.isWin = isWin
        self.pointsChange = pointsChange
        self.message = message
    }
}

// MARK: - UIColorHex

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        var r, g, b, a: CGFloat
        switch length {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            b = CGFloat(rgb & 0x0000FF) / 255
            a = alpha
        case 8:
            a = CGFloat((rgb & 0xFF000000) >> 24) / 255
            r = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            g = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            b = CGFloat(rgb & 0x000000FF) / 255
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
