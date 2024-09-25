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
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
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
        
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        
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

}
