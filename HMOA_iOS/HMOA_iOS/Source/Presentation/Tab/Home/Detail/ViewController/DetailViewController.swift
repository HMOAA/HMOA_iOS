//
//  DetailViewController.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/04.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class DetailViewController: UIViewController, View {
    
    // MARK: - Properties
    
    let DetailReactor = DetailViewReactor()
    var disposeBag = DisposeBag()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailSection>!

    let detailView = DetailView()
    
    let bottomView = DetailBottomView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackHomeSearchNaviBar("조말론 런던")
        configureUI()
        configureCollectionViewDataSource()
        bind(reactor: DetailReactor)
    }
}

// MARK: - Functions
extension DetailViewController {
    
    func bind(reactor: DetailViewReactor) {
        
        // state
        reactor.state
            .map { $0.sections }
            .bind(to: self.detailView.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPresentCommetVC }
            .distinctUntilChanged()
            .bind(onNext: presentCommentViewContorller)
            .disposed(by: disposeBag)
    }
    
    func configureCollectionViewDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<DetailSection>(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .topCell(let reactor):
                guard let perfumeInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PerfumeInfoCell.identifier, for: indexPath) as? PerfumeInfoCell else { return UICollectionViewCell() }
                
                perfumeInfoCell.reactor = reactor
                
                return perfumeInfoCell
            case .commentCell(let reactor):
                guard let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UICollectionViewCell() }
                
                commentCell.reactor = reactor
                
                return commentCell
            case .recommendCell(let perfume):
                guard let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCell.identifier, for: indexPath) as? SimilarCell else { return UICollectionViewCell() }
                
                similarCell.perfumeContentLabel.text = perfume.content
                similarCell.perfumeImageView.image = perfume.image
                similarCell.perfumetitleLabel.text = perfume.titleName
                
                return similarCell

            }
        }, configureSupplementaryView: { _, collectionView, kind, indexPath -> UICollectionReusableView in
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
                
                commentFooter.reactor = self.DetailReactor
                
                return commentFooter
            } else {
                return header
            }
        })
    }
    
    func configureUI() {
                        
        [   detailView,
            bottomView  ]   .forEach { view.addSubview($0) }
        
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
    }
}
