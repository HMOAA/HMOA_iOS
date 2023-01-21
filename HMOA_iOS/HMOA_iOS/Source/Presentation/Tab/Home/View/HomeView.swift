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
    
    // MARK: - ViewModel
    let viewModel = HomeViewModel.shared
    
    // MARK: - Properties
    let scrollView = UIScrollView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        $0.register(HomeTopCell.self, forCellWithReuseIdentifier: HomeTopCell.identifier)
        $0.register(HomeWatchCell.self, forCellWithReuseIdentifier: HomeWatchCell.identifier)
        $0.register(HomeCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeCellHeaderView.identifier)
        $0.register(HomeTopCellFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HomeTopCellFooterView.identifier)
        $0.register(HomeWatchCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeWatchCellHeaderView.identifier)
    }
    
    lazy var leftButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "leftButton"), for: .normal)
        
        return button
        
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "rightButton"), for: .normal)
        
        return button
    }()
    
    
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
        [scrollView] .forEach { addSubview($0) }
                
        [collectionView, leftButton, rightButton] .forEach { scrollView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(1050)
            $0.width.equalTo(scrollView)
        }
        
        leftButton.snp.makeConstraints {            $0.top.equalToSuperview().inset(93)
            $0.leading.equalToSuperview().inset(14)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(93)
            $0.trailing.equalToSuperview().inset(34)
        }
    }
    
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
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, scrollOffset, layoutEnvironment) in
            visibleItems.forEach { item in
                self!.viewModel.newsIndex = item.indexPath.row
            }
        }

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
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        
        let section = NSCollectionLayoutSection(group: finalGroup)
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
