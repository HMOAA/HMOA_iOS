//
//  OderLogViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/23/24.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class OrderLogViewController: UIViewController, View {

    // MARK: - UI Components
    
    private var noItemView = IconMessageView(title: "주문 내역이 없습니다", iconWidth: 110).then {
        $0.isHidden = true
    }
    
    private lazy var orderCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: createLayout()).then {
        $0.isHidden = true
        $0.register(OrderCell.self, forCellWithReuseIdentifier: OrderCell.identifier)
    }
    
    // MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<OrderLogSection, OrderLogItem>?
    
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
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
    }
    
    // MARK: - Bind
    
    func bind(reactor: OrderLogReactor) {
        
        // MARK: Action
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        rx.viewWillDisappear
            .map { _ in Reactor.Action.viewWillDisappear }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        orderCollectionView.rx.willDisplayCell
            .filter { $0.at.item == self.orderCollectionView.numberOfItems(inSection: 0) - 1 }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // MARK: State
        reactor.state
            .map { $0.orderList }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateCollectionViewIsHidden(isHidden: items.isEmpty)
                owner.updateSnapshot(forSection: .order, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushRefundVC }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self) { owner, _ in
                guard let order = reactor.currentState.selectedOrder else { return }
                owner.presentOrderCancelDetailViewController(order, orderCancelRequest: .refundRequest)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushReturnVC }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                guard let order = reactor.currentState.selectedOrder else { return }
                owner.presentOrderCancelDetailViewController(order, orderCancelRequest: .returnRequest)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushReviewVC }
            .filter { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                guard let orderID = reactor.currentState.selectedOrder?.order?.id else { return }
                owner.presentHBTIReviewWriteViewController(orderID: orderID)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("주문 내역", .black)
        view.backgroundColor = .white
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            orderCollectionView,
            noItemView
        ]   .forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        orderCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noItemView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 16, bottom: 100, trailing: 16)
            section.interGroupSpacing = 30
            
            return section
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: orderCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .order(let order):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: OrderCell.identifier,
                    for: indexPath) as! OrderCell
                
                cell.configureCell(order: order)
                
                cell.refundRequestButton.rx.tap
                    .map { Reactor.Action.didTapRefundButton(item) }
                    .bind(to: self.reactor!.action )
                    .disposed(by: cell.disposeBag)
                
                cell.returnRequestButton.rx.tap
                    .map { Reactor.Action.didTapReturnButton(item) }
                    .bind(to: self.reactor!.action )
                    .disposed(by: cell.disposeBag)
                
                cell.reviewButton.rx.tap
                    .map { Reactor.Action.didTapReviewButton(item) }
                    .bind(to: self.reactor!.action )
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<OrderLogSection, OrderLogItem>()
        initialSnapshot.appendSections([.order])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: OrderLogSection, withItems items: [OrderLogItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        snapshot.appendItems(items, toSection: section)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

extension OrderLogViewController {
    private func updateCollectionViewIsHidden(isHidden: Bool) {
        noItemView.isHidden = !isHidden
        orderCollectionView.isHidden = isHidden
    }
}
