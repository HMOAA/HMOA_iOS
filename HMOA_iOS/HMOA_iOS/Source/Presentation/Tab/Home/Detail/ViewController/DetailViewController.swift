//
//  DetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then

class DetailViewController: UIViewController {
    
    
    // MARK: - Properties
    
    let detailView = DetailView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle(title: "조 말론", color:  .white, isHidden: false)
        configureUI()
    }
}

// MARK: - Functions
extension DetailViewController {
    func configureUI() {
        
        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self
        
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension DetailViewController: UICollectionViewDelegate {

    
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }

        guard let perfumeInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PerfumeInfoCell.identifier, for: indexPath) as? PerfumeInfoCell else { return UICollectionViewCell() }
        
        guard let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCell.identifier, for: indexPath) as? SimilarCell else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            return perfumeInfoCell
        case 1:
            commentCell.contentLabel.text = "기존에 사용하던 향이라 재구매 했어요. 계절에 상관없이 사용할 수 있어서 좋아요. "
            return commentCell
        default:
            return similarCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = UICollectionReusableView()
        
        switch indexPath.section {
        case 1:
            guard let commentHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as? CommentHeaderView else { return UICollectionReusableView() }
            
            header = commentHeader
        default:
            guard let similarHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SimilarHeaderView.identifier, for: indexPath) as? SimilarHeaderView else { return UICollectionReusableView() }
            
            header = similarHeader
        }
        
        if kind == UICollectionView.elementKindSectionFooter {
            guard let commentFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier, for: indexPath) as? CommentFooterView else { return UICollectionReusableView() }
            
            return commentFooter
        } else {
            return header
        }
    }
}
