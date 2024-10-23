//
//  HBTIViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 7/11/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIViewController: UIViewController, View {
    
    // MARK: - UI Components
    
    private lazy var hbtiHomeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.register(HBTIHomeSurveyCell.self, forCellWithReuseIdentifier: HBTIHomeSurveyCell.identifier)
        $0.register(HBTIReviewCell.self, forCellWithReuseIdentifier: HBTIReviewCell.identifier)
        $0.register(HBTIHomeReviewHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: HBTIHomeReviewHeaderView.identifier)
    }
    
    // MARK: - Properties
    
    private var sections = [HBTIHomeSection]()
    private var dataSource: UICollectionViewDiffableDataSource<HBTIHomeSection, HBTIHomeItem>?
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setClearWhiteBackNaviBar("향BTI", .white)
        
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReactor) {
        
        // MARK: Action
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.isTapSurveyButton }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTISurveyViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isTapNoteButton }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTIPerfumeSurveyViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentHBTIReviewListViewController()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Add Views
    private func setAddView() {
        [
            hbtiHomeCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        hbtiHomeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sections = self.sections[sectionIndex]
            switch sections {
            case .survey:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .estimated(107)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(107)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(12)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 12
                section.boundarySupplementaryItems = []
                section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
                
                return section
            case .review:
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
                
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
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
                
                return section
            }
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: hbtiHomeCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .survey(let survey):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIHomeSurveyCell.identifier,
                    for: indexPath) as! HBTIHomeSurveyCell
                
                cell.configureCell(survey: survey)
                
                return cell
                
            case .review(let review):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIReviewCell.identifier,
                    for: indexPath) as! HBTIReviewCell
                
                cell.configureCell()
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: HBTIHomeReviewHeaderView.identifier, for: indexPath) as! HBTIHomeReviewHeaderView
                
                headerView.seeAllButton.rx.tap
                    .map { Reactor.Action.didTapSeeAllReviewButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: headerView.disposeBag)
                
                return headerView
                
            default:
                return nil
            }
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIHomeSection, HBTIHomeItem>()
        initialSnapshot.appendSections([.survey, .review])
        sections = initialSnapshot.sectionIdentifiers
        
        initialSnapshot.appendItems(HBTIHomeItem.surveys, toSection: .survey)
        initialSnapshot.appendItems([
            .review(HBTIReview(id: 1, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드")),
            .review(HBTIReview(id: 2, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드")),
            .review(HBTIReview(id: 3, profileImageURL: "", author: "작성자", content: "내용", imageCount: 0, photoList: [], date: "어제", isWrited: false, likeCount: 0, isLiked: false, orderTitle: "시향카드"))
        ], toSection: .review)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}
