//
//  NewsView.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/01/27.
//

import UIKit
import SnapKit
import Then

class NewsView: UIView {
    
    // MARK: - Properties
    
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        $0.register(NewsCellFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NewsCellFooterView.identifer)
        $0.register(NewsCellHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NewsCellHeaderView.identifier)
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Functions

extension NewsView {
    func configureUI() {
        [collectionView] .forEach { addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
