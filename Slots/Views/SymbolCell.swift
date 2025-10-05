//
//  SymbolCell.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class SymbolCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        configureAppearance()
        setupConstraints()
    }
    
    private func configureAppearance() {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    private func setupConstraints() {
        addSubview(symbolLabel)
        
        NSLayoutConstraint.activate([
            symbolLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Configuration
    func configure(with symbol: SlotSymbol) {
        symbolLabel.text = symbol.emoji
    }
}
