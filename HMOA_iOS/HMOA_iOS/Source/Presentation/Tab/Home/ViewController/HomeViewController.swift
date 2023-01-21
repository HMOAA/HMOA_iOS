//
//  HomeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: ViewModel
    
    let viewModel = HomeViewModel.shared
    
    // MARK: Properties
    
    lazy var homeView = HomeView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureAction()
        setNavigationSearchBar()
    }
    
    // MARK: objc functions
    
    @objc func leftButtonClicked() {
        DispatchQueue.main.async {
            self.homeView.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.newsIndex - 1, section: 0), at: .left, animated: true)

        }
    }
    
    @objc func rightButtonClicked() {
        DispatchQueue.main.async {
            self.homeView.collectionView.scrollToItem(at: IndexPath(row: self.viewModel.newsIndex + 1, section: 0), at: .right, animated: true)
        }
    }
}

// MARK: - Functions
extension HomeViewController {
    
    func configureUI() {
        view.backgroundColor = UIColor.white
        
        [homeView] .forEach { view.addSubview($0) }

        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        homeView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configureAction() {
        homeView.leftButton.addTarget(
            self,
            action: #selector(leftButtonClicked),
            for: .touchUpInside)
        
        homeView.rightButton.addTarget(
            self,
            action: #selector(rightButtonClicked),
            for: .touchUpInside)
    }
}


// MARK: CollectionView - Deleagte
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        
        guard let homeTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCell.identifier, for: indexPath) as? HomeTopCell else { return UICollectionViewCell() }
        
        guard let homeWatchCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeWatchCell.identifier, for: indexPath) as? HomeWatchCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            return homeTopCell
        case 3:
            return homeWatchCell
        default:
            homeCell.perfumeImageView.image = UIImage(named: "jomalon")
            homeCell.perfumeTitleLabel.text = "조 말론 런던"
            homeCell.perfumeInfoLabel.text = "우드 세이지 앤 씨 쏠트 코롱 100ml"
            return homeCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
             
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeTopCellFooterView.identifier, for: indexPath) as? HomeTopCellFooterView else { return UICollectionReusableView() }
        
        var header = UICollectionReusableView()
                
        switch indexPath.section {
        case 0:
            return footer
        case 3:
            guard let homeWatchCellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeWatchCellHeaderView.identifier, for: indexPath) as? HomeWatchCellHeaderView else { return UICollectionReusableView() }
            header = homeWatchCellHeader
        default:
            guard let homeCellheader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier, for: indexPath) as? HomeCellHeaderView else { return UICollectionReusableView() }
            header = homeCellheader
        }
        
        return header
    }
}

// MARK: CollectionView - DataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath) 클릭")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 3:
            return 7
        default:
            return 10
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(velocity)
    }
}
