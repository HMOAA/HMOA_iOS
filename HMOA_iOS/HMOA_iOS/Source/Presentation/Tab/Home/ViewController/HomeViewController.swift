//
//  HomeViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/12.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.homeTopCellCompositionalLayout()
            default:
                return self.homeCellCompositionalLayout()
            }
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        collectionView.register(HomeTopCell.self, forCellWithReuseIdentifier: HomeTopCell.identifier)
        collectionView.register(HomeCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier)
        collectionView.register(HomeTopCellFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeTopCellFooterView.identifier)
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
}

extension HomeViewController {
    
    func homeTopCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(202))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(202))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(33))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomLeading)
        sectionFooter.contentInsets = NSDirectionalEdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0)
        section.boundarySupplementaryItems = [ sectionFooter ]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func homeCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 1.5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.29), heightDimension: .absolute(170))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [ sectionHeader ]
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    func configureUI() {
        
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
    }
}


// MARK: CollectionView - Deleagte
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        
        guard let homeTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeTopCell.identifier, for: indexPath) as? HomeTopCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            return homeTopCell
        default:
            homeCell.perfumeImageView.image = UIImage(named: "jomalon")
            homeCell.perfumeTitleLabel.text = "조 말론 런던"
            homeCell.perfumeInfoLabel.text = "우드 세이지 앤 씨 쏠트 코롱 100ml"
            return homeCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier, for: indexPath) as? HomeCellHeaderView else { return UICollectionReusableView() }
     
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeTopCellFooterView.identifier, for: indexPath) as? HomeTopCellFooterView else { return UICollectionReusableView() }
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return footer
        default:
            return header
        }
    }
}

// MARK: CollectionView - DataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("클릭")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}
