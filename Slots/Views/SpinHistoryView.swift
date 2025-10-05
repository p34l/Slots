//
//  SpinHistoryView.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class SpinHistoryView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Spins"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private var spinHistory: [GameResult] = []
    
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
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layer.cornerRadius = 15
        
        addSubview(titleLabel)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SpinHistoryCell.self, forCellReuseIdentifier: "SpinHistoryCell")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Public Methods
    func updateHistory(_ history: [GameResult]) {
        spinHistory = history
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension SpinHistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spinHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpinHistoryCell", for: indexPath) as! SpinHistoryCell
        let result = spinHistory[indexPath.row]
        cell.configure(with: result)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SpinHistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - SpinHistoryCell
class SpinHistoryCell: UITableViewCell {
    
    private let symbolsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(symbolsLabel)
        addSubview(resultLabel)
        addSubview(pointsLabel)
        
        NSLayoutConstraint.activate([
            symbolsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            symbolsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            pointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            pointsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with result: GameResult) {
        // Display symbols
        let symbolTexts = result.symbols.map { $0.rawValue }
        symbolsLabel.text = symbolTexts.joined(separator: " ")
        
        // Display result
        resultLabel.text = result.isWin ? "WIN" : "LOSS"
        resultLabel.textColor = result.isWin ? .systemGreen : .systemRed
        
        // Display points change
        let pointsText = result.pointsChange > 0 ? "+\(result.pointsChange)" : "\(result.pointsChange)"
        pointsLabel.text = pointsText
        pointsLabel.textColor = result.pointsChange > 0 ? .systemGreen : .systemRed
    }
}
