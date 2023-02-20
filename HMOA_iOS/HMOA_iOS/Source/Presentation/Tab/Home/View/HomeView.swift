//
//  HomeView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/17.
//

import UIKit
import SnapKit
import Then

class HomeView: UIView {
        
    // MARK: - Properties
    let scrollView = UIScrollView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        $0.register(HomeTopCell.self, forCellWithReuseIdentifier: HomeTopCell.identifier)
        $0.register(HomeWatchCell.self, forCellWithReuseIdentifier: HomeWatchCell.identifier)
        $0.register(HomeCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier)
        $0.register(HomeWatchCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeWatchCellHeaderView.identifier)
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions

extension HomeView {
    
    func configureUI() {
        [collectionView] .forEach { addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func homeTopCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(460))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(460))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func homeCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(126), heightDimension: .estimated(126))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 1.5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(126), heightDimension: .estimated(126))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [ sectionHeader ]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0)
        section.contentInsets = NSDirectionalEdgeInsets(top: 74, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
    func homeWatchCellCompositionalLayout() -> NSCollectionLayoutSection {
        
        let leftItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        
        let leftBottomHalfItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        
        leftBottomHalfItem.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 6)
        
        let leftBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        
        leftBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
        
        let leftBottomHalfGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitems: [leftBottomHalfItem, leftBottomHalfItem])
        
        let leftBottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)), subitems: [leftBottomHalfGroup, leftBottomItem])
        
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1)), subitems: [leftItem, leftBottomGroup])
        
        let rightTopHalfFirstItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1)))
        
        rightTopHalfFirstItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 6)
        
        let rightTopHalfSecondItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1)))
        
        rightTopHalfSecondItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0)
       
        let rightTopHalfGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), subitems: [rightTopHalfFirstItem, rightTopHalfSecondItem])
        
        let rightButtomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)))
        
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1)), subitems: [rightTopHalfGroup, rightButtomItem])
        
        rightGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 20)
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(306)), subitems: [leftGroup, rightGroup])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        
        let section = NSCollectionLayoutSection(group: finalGroup)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0)
        section.contentInsets = NSDirectionalEdgeInsets(top: 74, leading: 0, bottom: 40, trailing: 0)

        section.boundarySupplementaryItems = [ sectionHeader ]

        return section
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.homeTopCellCompositionalLayout()
            case 3:
                return self.homeWatchCellCompositionalLayout()
            default:
                return self.homeCellCompositionalLayout()
            }
        }
    }
}
