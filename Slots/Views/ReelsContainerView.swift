//
//  ReelsContainerView.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class ReelsContainerView: UIView {
    private var backgroundView: UIView!
    private var containerView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContainer()
    }

    private func setupContainer() {
        createBackgroundView()
        createContainerView()
        setupConstraints()
        setupObserver()
    }

    private func createBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: "3C467B")
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = ReelsViewConstants.shadowOffset
        backgroundView.layer.shadowOpacity = ReelsViewConstants.shadowOpacity
        backgroundView.layer.shadowRadius = ReelsViewConstants.shadowRadius
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor(hex: "80A1BA")
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = ReelsViewConstants.borderWidth
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: ReelsViewConstants.backgroundSizeMultiplier),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: ReelsViewConstants.backgroundSizeMultiplier),

            containerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: ReelsViewConstants.containerSizeMultiplier),
            containerView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: ReelsViewConstants.containerSizeMultiplier),
        ])
    }

    private func setupObserver() {
        backgroundView.addObserver(self, forKeyPath: "bounds", options: [.new], context: nil)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "bounds", object as? UIView == backgroundView else { return }
        updateCornerRadius()
    }

    private func updateCornerRadius() {
        let minDimension = min(backgroundView.bounds.width, backgroundView.bounds.height)
        let radius = minDimension * ReelsViewConstants.cornerRadiusMultiplier
        backgroundView.layer.cornerRadius = radius
        containerView.layer.cornerRadius = radius * ReelsViewConstants.containerRadiusMultiplier
    }

    deinit {
        backgroundView.removeObserver(self, forKeyPath: "bounds")
    }

    func getContainerView() -> UIView {
        return containerView
    }
}
