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
    
    enum SupplementaryViewKind: String {
        case survey = "survey"
        case review = "review"
    }
    
    // MARK: - UI Components
    
    private lazy var hbtiHomeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .clear
        $0.register(HBTIHomeSurveyCell.self, forCellWithReuseIdentifier: HBTIHomeSurveyCell.identifier)
        $0.register(HBTIReviewCell.self, forCellWithReuseIdentifier: HBTIReviewCell.identifier)
        
        $0.register(HBTIHomeSurveyHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.survey.rawValue, withReuseIdentifier: HBTIHomeSurveyHeaderView.identifier)
        $0.register(HBTIHomeReviewHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.review.rawValue, withReuseIdentifier: HBTIHomeReviewHeaderView.identifier)
    }
    
    private lazy var optionView = OptionView().then {
        $0.reactor = OptionReactor()
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
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTIReactor) {
        
        // MARK: Action
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // survey item 터치
        hbtiHomeCollectionView.rx.itemSelected
            .filter { $0.section == 0 }
            .map { Reactor.Action.didTapSurveyCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //
        hbtiHomeCollectionView.rx.itemSelected
            .filter { $0.section == 1 }
            .map { Reactor.Action.didTapOptionButton($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        optionView.reactor?.state
            .map { $0.isTapDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Reactor.Action.didTapDeleteReview }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.topReviewList }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, item in
                owner.updateSnapshot(forSection: .review, withItem: item)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNoteSurvey }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTISurveyViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushPerfumeSurvey }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(onNext: presentHBTIPerfumeSurveyViewController)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushAllReviewList }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, _ in
                owner.presentHBTIReviewListViewController(isLog: false)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Add Views
    private func setAddView() {
        [
            hbtiHomeCollectionView,
            optionView
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        hbtiHomeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        optionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sections = self.sections[sectionIndex]
            switch sections {
            case .survey:
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.survey.rawValue, alignment: .top)
                
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
                section.boundarySupplementaryItems = [headerItem]
                section.contentInsets = .init(top: 20, leading: 16, bottom: 20, trailing: 16)
                
                return section
            case .review:
                let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
                let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.review.rawValue, alignment: .top)
                
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
                
                cell.reviewView.configureView(review: review)
                cell.reviewView.bindPhotoCollectionView(review.photoList)
                
                cell.reviewView.heartButton.rx.tap
                    .map { Reactor.Action.didTapLikeButton(indexPath.row) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                self.reactor!.state
                    .map { $0.topReviewList[indexPath.row] }
                    .asDriver(onErrorRecover: { _ in .empty() })
                    .drive(with: self, onNext: { owner, item in
                        guard let review = item.review else { return }
                        cell.reviewView.heartButton.isSelected = review.isLiked
                        cell.reviewView.likeCountLabel.text = String(review.likeCount)
                    })
                    .disposed(by: cell.disposeBag)
                
                self.reactor!.state
                    .map { _ in item.review!.photoList }
                    .distinctUntilChanged()
                    .observe(on: MainScheduler.instance)
                    .bind(to: cell.reviewView.photoCollectionView.rx.items(cellIdentifier: PhotoCell.identifier, cellType: PhotoCell.self)) { row, item, cell in
                        cell.isZoomEnabled = false
                        cell.imageView.kf.setImage(with: URL(string: item.photoUrl))
                        cell.backgroundColor = .black
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.reviewView.photoCollectionView.rx.itemSelected
                    .bind(with: self, onNext: { owner, indexPath in
                        owner.presentImageListVC(indexPath, images: item.review!.photoList)
                    })
                    .disposed(by: cell.disposeBag)
                
                self.optionView.parentVC = self
                
                let optionReviewData = OptionReviewData(id: review.id,
                                                        content: review.content,
                                                        isWrited: review.isWrited)
                
                cell.reviewView.optionButton.rx.tap
                    .map { OptionReactor.Action.didTapOptionButton(.Review(optionReviewData)) }
                    .bind(to: self.optionView.reactor!.action)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        })
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.survey.rawValue:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.survey.rawValue, withReuseIdentifier: HBTIHomeSurveyHeaderView.identifier, for: indexPath) as! HBTIHomeSurveyHeaderView
                
                return headerView
                
            case SupplementaryViewKind.review.rawValue:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.review.rawValue, withReuseIdentifier: HBTIHomeReviewHeaderView.identifier, for: indexPath) as! HBTIHomeReviewHeaderView
                
                headerView.seeAllButton.rx.tap
                    .map { Reactor.Action.didTapSeeAllReviewButton }
                    .bind(to: self.reactor!.action)
                    .disposed(by: headerView.disposeBag)
                
                return headerView
                
            default:
                return nil
            }
        }
        
        // MARK: Initial Snapshot
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIHomeSection, HBTIHomeItem>()
        initialSnapshot.appendSections([.survey, .review])
        sections = initialSnapshot.sectionIdentifiers
        
        initialSnapshot.appendItems(HBTIHomeItem.surveys, toSection: .survey)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    // MARK: Update Snapshot
    private func updateSnapshot(forSection section: HBTIHomeSection, withItem item: [HBTIHomeItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        snapshot.appendItems(item, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
