//
//  ReelsView.swift
//  Slots
//
//  Created by Misha Kandaurov on 03.10.2025.
//

import UIKit

class ReelsView: UIView {
    
    // MARK: - Properties
    private var reels: [UICollectionView] = []
    private var reelData: [[SlotSymbol]] = [[], [], []]
    private var containerView: ReelsContainerView!
    private var animationManager: ReelsAnimationManager!
    private var winAnimationManager: ReelsWinAnimationManager!
    
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
        setupContainer()
        setupReels()
        setupManagers()
    }
    
    private func setupContainer() {
        containerView = ReelsContainerView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupReels() {
        let stackView = createReelsStackView()
        createReels(for: stackView)
        setupReelsConstraints(stackView)
        populateReels()
    }
    
    private func setupManagers() {
        animationManager = ReelsAnimationManager(reels: reels, reelData: reelData)
        winAnimationManager = ReelsWinAnimationManager(containerView: containerView, reels: reels)
    }
    
    private func createReelsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createReels(for stackView: UIStackView) {
        for i in 0..<ReelsViewConstants.numberOfReels {
            let collectionView = createCollectionView(tag: i)
            stackView.addArrangedSubview(collectionView)
            reels.append(collectionView)
        }
    }
    
    private func createCollectionView(tag: Int) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(SymbolCell.self, forCellWithReuseIdentifier: "SymbolCell")
        collectionView.tag = tag
        return collectionView
    }
    
    private func setupReelsConstraints(_ stackView: UIStackView) {
        let container = containerView.getContainerView()
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: ReelsViewConstants.containerPadding),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: ReelsViewConstants.containerPadding),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -ReelsViewConstants.containerPadding),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -ReelsViewConstants.containerPadding)
        ])
    }
    
    private func populateReels() {
        for i in 0..<ReelsViewConstants.numberOfReels {
            let symbols = generateRandomSymbols()
            reelData[i] = symbols
            reels[i].reloadData()
            setInitialPosition(for: reels[i])
        }
    }
    
    private func generateRandomSymbols() -> [SlotSymbol] {
        return (0..<ReelsViewConstants.numberOfSymbols).map { _ in
            SlotSymbol.allCases.randomElement() ?? .cherry
        }
    }
    
    private func setInitialPosition(for reel: UICollectionView) {
        let cellHeight = reel.frame.height
        reel.contentOffset.y = CGFloat(ReelsViewConstants.centerPosition) * cellHeight
    }
    
    // MARK: - Public Methods
    func setDataSource(_ dataSource: UICollectionViewDataSource) {
        reels.forEach { $0.dataSource = dataSource }
    }

    func setDelegate(_ delegate: UICollectionViewDelegate) {
        reels.forEach { $0.delegate = delegate }
    }

    func spinReels(to symbols: [SlotSymbol], completion: @escaping () -> Void) {
        animationManager.spinReels(to: symbols, completion: completion)
    }
    
    func getReelData(for index: Int) -> [SlotSymbol] {
        return index < reelData.count ? reelData[index] : []
    }
    
    func startWinAnimation() {
        winAnimationManager.startWinAnimation()
    }
}
