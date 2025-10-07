//
//  GameViewController.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class GameViewController: UIViewController {
    private let gameModel = GameModel()
    private var isSpinning = false

    private let scoreView = ScoreView()
    private let reelsView = ReelsView()
    private let resultLabel = ResultLabel()
    private let spinButton = SpinButton()
    private let spinToWinButton = SpinButton()
    private let spinHistoryView = SpinHistoryView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargetSpinButton()
        updateScore()
        updateSpinHistory()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupUI() {
        view.backgroundColor = .systemIndigo

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemIndigo.cgColor,
            UIColor.systemPurple.cgColor,
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white

        view.addSubview(scoreView)
        view.addSubview(reelsView)
        view.addSubview(resultLabel)
        view.addSubview(spinButton)
        view.addSubview(spinToWinButton)
        view.addSubview(spinHistoryView)

        setupConstraints()
        setupReels()
    }

    private func setupConstraints() {
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        reelsView.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        spinToWinButton.translatesAutoresizingMaskIntoConstraints = false
        spinHistoryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scoreView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            scoreView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),

            reelsView.topAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: 16),
            reelsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reelsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reelsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),

            resultLabel.topAnchor.constraint(equalTo: reelsView.bottomAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08),

            spinButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 16),
            spinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            spinButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06),

            spinToWinButton.topAnchor.constraint(equalTo: spinButton.bottomAnchor, constant: 12),
            spinToWinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinToWinButton.widthAnchor.constraint(equalTo: spinButton.widthAnchor),
            spinToWinButton.heightAnchor.constraint(equalTo: spinButton.heightAnchor),

            spinHistoryView.topAnchor.constraint(equalTo: spinToWinButton.bottomAnchor, constant: 24),
            spinHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            spinHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            spinHistoryView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            spinHistoryView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    private func setupReels() {
        reelsView.setDataSource(self)
        reelsView.setDelegate(self)
    }

    private func addTargetSpinButton() {
        spinButton.addTarget(self, action: #selector(spinButtonTapped), for: .touchUpInside)
        spinToWinButton.addTarget(self, action: #selector(spinToWinButtonTapped), for: .touchUpInside)
        spinToWinButton.setTitle("Крутити до\nвиграшу", for: .normal)
        spinToWinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        spinToWinButton.titleLabel?.numberOfLines = 2
        spinToWinButton.titleLabel?.textAlignment = .center
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func spinButtonTapped() {
        guard !isSpinning else { return }

        isSpinning = true
        spinButton.setEnabled(false)
        spinToWinButton.setEnabled(false)
        resultLabel.hideResult()

        SoundManager.shared.playSound(.gameStart)

        let result = gameModel.spin()

        reelsView.spinReels(to: result.symbols) { [weak self] in
            self?.handleSpinResult(result)
        }
    }

    @objc private func spinToWinButtonTapped() {
        guard !isSpinning else { return }

        isSpinning = true
        spinButton.setEnabled(false)
        spinToWinButton.setEnabled(false)
        resultLabel.hideResult()

        spinUntilWin()
    }

    private func handleSpinResult(_ result: GameResult) {
        updateScore()
        resultLabel.showResult(result.message, isWin: result.isWin)
        updateSpinHistory()

        if result.isWin {
            SoundManager.shared.playSound(.win)
            reelsView.startWinAnimation()
        } else {
            SoundManager.shared.playSound(.lose)
        }

        isSpinning = false
        spinButton.setEnabled(true)
        spinToWinButton.setEnabled(true)
    }

    private func spinUntilWin() {
        SoundManager.shared.playSound(.gameStart)

        let result = gameModel.spin()

        reelsView.spinReels(to: result.symbols) { [weak self] in
            guard let self = self else { return }

            self.updateScore()
            self.updateSpinHistory()

            if result.isWin {
                self.resultLabel.showResult(result.message, isWin: result.isWin)
                SoundManager.shared.playSound(.win)
                self.reelsView.startWinAnimation()
                self.isSpinning = false
                self.spinButton.setEnabled(true)
                self.spinToWinButton.setEnabled(true)
            } else {
                self.resultLabel.showResult(result.message, isWin: result.isWin)
                SoundManager.shared.playSound(.lose)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.spinUntilWin()
                }
            }
        }
    }

    private func updateScore() {
        scoreView.updateScore(gameModel.balance)
    }

    private func updateSpinHistory() {
        spinHistoryView.updateHistory(gameModel.getRecentSpins())
    }
}

// MARK: - UICollectionViewDataSource

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let reelIndex = collectionView.tag
        return reelsView.getReelData(for: reelIndex).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SymbolCell", for: indexPath) as! SymbolCell
        let reelIndex = collectionView.tag
        let symbols = reelsView.getReelData(for: reelIndex)

        if indexPath.item < symbols.count {
            cell.configure(with: symbols[indexPath.item])
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
