//
//  WelcomeViewController.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "🎰"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Slots"
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Грати", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargetPlayButton()
        title = "Slots"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }

    private func addTargetPlayButton() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }

    @objc private func playButtonTapped() {
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }

    private func setupUI() {
        view.backgroundColor = .systemPurple

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemBlue.cgColor,
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(logoLabel)
        view.addSubview(titleLabel)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),

            titleLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 200),
            playButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

