//
//  ResultLabel.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class ResultLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        font = UIFont.systemFont(ofSize: 28, weight: .bold)
        textAlignment = .center
        textColor = .white
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 15
        clipsToBounds = true
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    func showResult(_ message: String, isWin: Bool) {
        text = message
        textColor = isWin ? .systemGreen : .systemRed
        backgroundColor = isWin ? UIColor.systemGreen.withAlphaComponent(0.2) : UIColor.systemRed.withAlphaComponent(0.2)

        isHidden = false
        alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
        })

        if isWin {
            startBlinkingAnimation()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hideResult()
        }
    }

    func hideResult() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
        }
    }

    private func startBlinkingAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.3
        }) { _ in
            self.alpha = 1
        }
    }
}
