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
import RxGesture

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
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.layer.cornerRadius = 10
        $0.axis = .vertical
        $0.spacing = 4
        $0.layoutMargins = .init(top: 8, left: 4, bottom: 8, right: 4)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var floatingView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        $0.alpha = 0
        $0.isHidden = true
    }
    
    private lazy var optionView = OptionView().then {
        $0.reactor = OptionReactor()
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
        
        let isLog = reactor!.currentState.isLog
        view.backgroundColor = isLog ? .white : .black
        setClearBackNaviBar(isLog ? "작성한 후기" : "향BTI 후기", isLog ? .black : .white)
        navigationController?.navigationBar.backgroundColor = .clear
        
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
                make.trailing.equalToSuperview().inset(24)
                make.height.greaterThanOrEqualTo(16)
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
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear
            .map { _ in Reactor.Action.viewDidAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 리뷰 마지막 아이템이 나타나면 다음 페이지 로드
        hbtiReviewListCollectionView.rx.willDisplayCell
            .filter { cellInfo in
                let itemIndex = cellInfo.at.item
                let numberOfItems = self.hbtiReviewListCollectionView.numberOfItems(inSection: 0) - 1
                return itemIndex == numberOfItems
            }
            .map { _ in Reactor.Action.loadReviewListNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        floatingButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(350), scheduler: MainScheduler.instance)
            .map { Reactor.Action.didTapFloatingButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        floatingView.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.didTapFloatingBackView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.reviewList }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, item in
                owner.updateSnapshot(forSection: .review, withItem: item)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isFloatingButtonTap }
            .skip(1)
            .asDriver(onErrorRecover: { _ in return .empty() })
            .drive(with: self, onNext: { owner, isTap in
                owner.showFloatingButtonAnimation(
                    floatingButton: owner.floatingButton,
                    stackView: owner.floatingStackView,
                    backgroundView: owner.floatingView,
                    isTap: isTap)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.notReviewedOrderList }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, orderList in
                owner.floatingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                orderList.forEach { order in
                    let button = UIButton().makeHBTIFloatingListButton(title: order.info)
                    button.rx.tap
                        .map { Reactor.Action.didTapWriteReviewButton(order.id)}
                        .bind(to: reactor.action)
                        .disposed(by: self.disposeBag)
                    owner.floatingStackView.addArrangedSubview(button)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushReviewWriteVC }
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, isPush in
                guard let orderID = reactor.currentState.selectedOrderID else { return }
                owner.presentHBTIReviewWriteViewController(orderID: orderID)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        hbtiReviewListCollectionView.backgroundColor = .clear
    }
    
    // MARK: Add Views
    private func setAddView() {
        
        [
            hbtiReviewListCollectionView,
            optionView
        ].forEach { view.addSubview($0) }
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        hbtiReviewListCollectionView.snp.makeConstraints { make in
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
                cell.reviewView.bindPhotoCollectionView(review.photoList)
                
                cell.reviewView.heartButton.rx.tap
                    .map { Reactor.Action.didTapLikeButton(indexPath.row) }
                    .bind(to: self.reactor!.action)
                    .disposed(by: cell.disposeBag)
                
                self.reactor!.state
                    .map { $0.reviewList[indexPath.row] }
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
                
                // 옵션 버튼
                self.optionView.parentVC = self
            
                // TODO: 실제 데이터로 변경
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
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIReviewListSection, HBTIReviewListItem>()
        initialSnapshot.appendSections([.review])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    // MARK: Update Snapshot
    private func updateSnapshot(forSection section: HBTIReviewListSection, withItem item: [HBTIReviewListItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        snapshot.appendItems(item, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
