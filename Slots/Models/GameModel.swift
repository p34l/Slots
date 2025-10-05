//
//  GameModel.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import Foundation

class GameModel {
    private(set) var balance: Int = 1000
    private(set) var spinHistory: [GameResult] = []
    private let maxHistoryCount = 5

    private let balanceKey = "SlotsBalance"
    private let historyKey = "SlotsHistory"

    init() {
        loadData()
    }

    func spin() -> GameResult {
        let symbols = generateRandomSymbols()
        let result = GameResult(symbols: symbols)

        balance += result.pointsChange

        spinHistory.insert(result, at: 0)

        if spinHistory.count > maxHistoryCount {
            spinHistory = Array(spinHistory.prefix(maxHistoryCount))
        }

        saveData()

        return result
    }

    private func generateRandomSymbols() -> [SlotSymbol] {
        return (0 ..< 3).map { _ in
            SlotSymbol.allCases.randomElement() ?? .cherry
        }
    }

    func getRecentSpins() -> [GameResult] {
        return spinHistory
    }

    private func saveData() {
        UserDefaults.standard.set(balance, forKey: balanceKey)

        let historyData = spinHistory.map { result in
            [
                "symbols": result.symbols.map { $0.rawValue },
                "isWin": result.isWin,
                "pointsChange": result.pointsChange,
                "message": result.message,
            ]
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: historyData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: historyKey)
        }
    }

    private func loadData() {
        if UserDefaults.standard.object(forKey: balanceKey) != nil {
            balance = UserDefaults.standard.integer(forKey: balanceKey)
        }

        if let jsonString = UserDefaults.standard.string(forKey: historyKey),
           let jsonData = jsonString.data(using: .utf8),
           let historyArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] {
            spinHistory = historyArray.compactMap { dict in
                guard let symbolStrings = dict["symbols"] as? [String],
                      let isWin = dict["isWin"] as? Bool,
                      let pointsChange = dict["pointsChange"] as? Int,
                      let message = dict["message"] as? String else {
                    return nil
                }

                let symbols = symbolStrings.compactMap { SlotSymbol(rawValue: $0) }
                guard symbols.count == 3 else { return nil }

                return GameResult(symbols: symbols, isWin: isWin, pointsChange: pointsChange, message: message)
            }
        }
    }

    func resetGame() {
        balance = 1000
        spinHistory = []
        saveData()
    }
}
