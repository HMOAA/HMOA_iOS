//
//  SearchResultViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/27.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    // MARK: - UI Component
    
    lazy var topView = SearchResultTopView()
    
    lazy var layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SearchResultViewController {
    
    // MARK: - Configure
    func configureUI() {

        collectionView.delegate = self
        
        [   topView,
            collectionView
        ]   .forEach { view.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(3)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 40) / 2
        let height = width + 82
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
