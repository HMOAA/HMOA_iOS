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
import Then

final class HBTIReviewListViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private lazy var hbtiReviewListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(HBTIReviewCell.self, forCellWithReuseIdentifier: HBTIReviewCell.identifier)
    }
    
    private let floatingButton = UIButton().then {
        $0.setImage(UIImage(named: "addButton"), for: .normal)
        $0.setImage(UIImage(named: "selectedAddButton"), for: .selected)
    }
    
    private let floatingStackView = UIStackView().then {
        $0.alpha = 0
        $0.backgroundColor = .black
        $0.isHidden = true
        $0.distribution = .fillEqually
        $0.layer.cornerRadius = 10
        $0.axis = .vertical
    }
    
    private lazy var floatingView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        $0.alpha = 0
        $0.isHidden = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if reactor!.currentState.isLog { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            [
                floatingView,
                floatingButton,
                floatingStackView
            ]   .forEach { window.addSubview($0) }
            
            floatingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            floatingButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(24)
                make.bottom.equalToSuperview().inset(32)
                make.width.height.equalTo(56)
            }
            
            floatingStackView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(8)
                make.width.equalTo(135)
                make.height.equalTo(137)
                make.bottom.equalTo(floatingButton.snp.top).offset(-8)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if reactor!.currentState.isLog { return }
        floatingStackView.removeFromSuperview()
        floatingView.removeFromSuperview()
        floatingButton.removeFromSuperview()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReviewListReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        let isLog = reactor!.currentState.isLog
        view.backgroundColor = isLog ? .white : .black
        setClearBackNaviBar(isLog ? "작성한 후기" : "향BTI 후기", isLog ? .black : .white)
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
                
                cell.reviewView.configureView(review: review)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIReviewListSection, HBTIReviewListItem>()
        initialSnapshot.appendSections([.review])
        initialSnapshot.appendItems([
            HBTIReviewListItem.review(HBTIReview(id: 1, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드")),
            HBTIReviewListItem.review(HBTIReview(id: 2, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드")),
            HBTIReviewListItem.review(HBTIReview(id: 3, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드"))
        ], toSection: .review)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}
