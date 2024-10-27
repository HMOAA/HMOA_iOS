//
//  HBTINotesResultViewController.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/20/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import ReactorKit

final class HBTINotesResultViewController: UIViewController, View {
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    private var dataSource: UICollectionViewDiffableDataSource<HBTINotesResultSection, HBTINotesResultItem>?
    
    // MARK: - UI Components
    
    private let headerView = HBTINotesResultHeaderView()
    
    private lazy var notesResultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            HBTINotesResultCell.self,
            forCellWithReuseIdentifier: HBTINotesResultCell.reuseIdentifier
        )
        $0.showsVerticalScrollIndicator = false
    }
    
    private let footerView = HBTINotesResultFooterView()
    
    private let nextButton: UIButton = UIButton().makeValidHBTINextButton(title: "다음")
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    // MARK: - Bind
    
    func bind(reactor: HBTINotesResultReactor) {
        
        // MARK: Action
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { HBTINotesResultReactor.Action.didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // MARK: State
        
        reactor.state
            .map { $0.cartItemList }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, items in
                owner.updateSnapshot(forSection: .notesResult, withItems: items)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.totalPrice }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, price in
                owner.footerView.configurePriceLabel(price: price)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPushNextVC }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .empty() })
            .drive(with: self, onNext: { owner, _ in
                let orderNoteList = owner.reactor?.currentState.selectedNoteList ?? []
                  
                owner.presentHBTIOrderSheetViewController(orderNoteList)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Set UI
    
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향BTI")
    }
    
    // MARK: Add Views
    
    private func setAddView() {
        [
         headerView,
         notesResultCollectionView,
         footerView,
         nextButton
        ].forEach(view.addSubview)
    }
    
    // MARK: Set Constraints
    
    private func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(127)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        notesResultCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(footerView.snp.top).offset(-8)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    // MARK: Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(142)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(142)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: Configure DataSource
    
    private func configureDataSource() {
        dataSource = .init(collectionView: notesResultCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .notesResult(let cartItem):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTINotesResultCell.reuseIdentifier,
                    for: indexPath) as! HBTINotesResultCell
                
                cell.configureCell(cartItem: cartItem)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTINotesResultSection, HBTINotesResultItem>()
        initialSnapshot.appendSections([.notesResult])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateSnapshot(forSection section: HBTINotesResultSection, withItems items: [HBTINotesResultItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
