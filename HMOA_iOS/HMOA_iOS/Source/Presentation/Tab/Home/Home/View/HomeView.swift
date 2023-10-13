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
        $0.register(HomeFirstCell.self, forCellWithReuseIdentifier: HomeFirstCell.identifier)
        $0.register(HomeCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier)
        $0.register(HomeFirstCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeFirstCellHeaderView.identifier)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.3778))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.3778))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }
    
    func homeCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(126), heightDimension: .absolute(126))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 1.5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(126), heightDimension: .absolute(126))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [ sectionHeader ]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0)
        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 16, bottom: 70, trailing: 0)
        return section
    }
    
    func homeFirstCellCompositionalLayout() -> NSCollectionLayoutSection {
        
        let leftTopItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.55)))
        
        let leftBottomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.45)))
        
        leftBottomItem.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 0)
        
        let leftGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.37), heightDimension: .fractionalHeight(1)), subitems: [leftTopItem, leftBottomItem])
        
        let rightTopHalfFirstItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1)))
        
        rightTopHalfFirstItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 6)
        
        let rightTopHalfSecondItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.55), heightDimension: .fractionalHeight(1)))
        
        rightTopHalfSecondItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0)
       
        let rightTopHalfGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), subitems: [rightTopHalfFirstItem, rightTopHalfSecondItem])
        
        let rightButtomItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6)))
        
        let rightGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.63), heightDimension: .fractionalHeight(1)), subitems: [rightTopHalfGroup, rightButtomItem])
        
        rightGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 0)
        
        let finalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350)), subitems: [leftGroup, rightGroup])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        
        let section = NSCollectionLayoutSection(group: finalGroup)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 26, leading: 0, bottom: -12, trailing: -16)
        section.contentInsets = NSDirectionalEdgeInsets(top: 38, leading: 16, bottom: 40, trailing: 16)

        section.boundarySupplementaryItems = [ sectionHeader ]

        return section
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.homeTopCellCompositionalLayout()
            case 1:
                return self.homeFirstCellCompositionalLayout()
            default:
                return self.homeCellCompositionalLayout()
            }
        }
    }
}
