//
//  HBTIReviewListViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 10/22/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIReviewListViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private lazy var hbtiReviewListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(HBTIReviewCell.self, forCellWithReuseIdentifier: HBTIReviewCell.identifier)
    }
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTIReviewListSection, HBTIReviewListItem>?
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReviewListReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .black
        setClearWhiteBackNaviBar("향BTI 후기", .white)
        hbtiReviewListCollectionView.backgroundColor = .clear
    }
    
    // MARK: Add Views
    private func setAddView() {
        
        [
            hbtiReviewListCollectionView
        ].forEach { view.addSubview($0) }
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        hbtiReviewListCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(130)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(130)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
            
            return section
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: hbtiReviewListCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .review(let review):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIReviewCell.identifier,
                    for: indexPath) as! HBTIReviewCell
                
                cell.configureCell()
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIReviewListSection, HBTIReviewListItem>()
        initialSnapshot.appendSections([.review])
        initialSnapshot.appendItems([HBTIReviewListItem.review(HBTIReview(id: 1, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드"))], toSection: .review)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}
