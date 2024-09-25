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
    
    private lazy var orderCollectionView = UICollectionView(frame: .zero,
                                                            collectionViewLayout: createLayout()).then {
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
    
    // MARK: - Bind
    
    func bind(reactor: OrderLogReactor) {
        
        // MARK: Action
        
        // MARK: State
    }
    
    // MARK: - Functions
    
    private func setUI() {
        setClearBackNaviBar("주문 내역", .black)
        view.backgroundColor = .white
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            orderCollectionView
        ]   .forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        orderCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
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
                
                // TODO: configureCell 호출
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<OrderLogSection, OrderLogItem>()
        initialSnapshot.appendSections([.order])
        
        initialSnapshot.appendItems([.order("1"), .order("2")])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}
