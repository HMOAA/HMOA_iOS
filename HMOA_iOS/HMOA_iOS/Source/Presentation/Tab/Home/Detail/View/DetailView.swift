//
//  DetailView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

class DetailView: UIView {
    
    // MARK: - Properies

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(SimilarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimilarHeaderView.identifier)
        $0.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        $0.register(PerfumeInfoCell.self, forCellWithReuseIdentifier: PerfumeInfoCell.identifier)
        $0.register(SimilarCell.self, forCellWithReuseIdentifier: SimilarCell.identifier)
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Functions

extension DetailView {
    func configureUI() {
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func perfumeInfoCellCompositionalLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(800)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(800)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func commentCellCompositionalLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100)), subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return section
    }
    
    func similarCellCompositionalLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .estimated(140)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.29), heightDimension: .estimated(140)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(22)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 65, leading: 0, bottom: 0, trailing: 0)
        
        
        section.boundarySupplementaryItems = [ sectionHeader ]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 80, leading: 20, bottom: 0, trailing: 0)

        return section
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self.perfumeInfoCellCompositionalLayout()
            case 1:
                return self.commentCellCompositionalLayout()
            default:
                return self.similarCellCompositionalLayout()
            }
        }
    }
}
