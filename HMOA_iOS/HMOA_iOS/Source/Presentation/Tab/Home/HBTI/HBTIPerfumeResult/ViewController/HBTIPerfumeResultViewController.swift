//
//  HBTIPerfumeResultViewController.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/8/24.
//

import UIKit

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HBTIPerfumeResultViewController: UIViewController, View {

    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "고객님에게 어울릴 향수는", lineHeight: 27)
    }
    
    private let priceButton = UIButton().then {
        $0.setHBTIPriorityButton(title: "가격대 우선")
        $0.isSelected = true
    }
    
    private let noteButton = UIButton().then {
        $0.setHBTIPriorityButton(title: "향료 우선")
        $0.isSelected = false
    }
    
    private lazy var perfumeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(HBTIPerfumeResultCell.self,
                    forCellWithReuseIdentifier: HBTIPerfumeResultCell.identifier)
    }
    
    // MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<HBTIPerfumeResultSection, HBTIPerfumeResultItem>?
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    func bind(reactor: HBTIPerfumeResultReactor) {
        
        // MARK: Action
        
        
        // MARK: State
        
    }
    
    // MARK: - Functions
    
    // MARK: Set UI
    private func setUI() {
        view.backgroundColor = .white
        setBackItemNaviBar("향수 추천")
    }
    
    // MARK: Add Views
    private func setAddView() {
        [
            titleLabel,
            priceButton,
            noteButton,
            perfumeCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    // MARK: Set Constraints
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(56)
            make.height.equalTo(12)
        }
        
        noteButton.snp.makeConstraints { make in
            make.top.equalTo(priceButton.snp.top)
            make.leading.equalTo(priceButton.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(12)
        }
        
        perfumeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(priceButton.snp.bottom).offset(22)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
            let centerImageWidth = availableLayoutWidth * 0.78
            let centerImageHeight = centerImageWidth / 280 * 354
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.78), heightDimension: .absolute(centerImageHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40)
            section.interGroupSpacing = 16
            
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: perfumeCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .perfume(let perfume):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIPerfumeResultCell.identifier,
                    for: indexPath) as! HBTIPerfumeResultCell
                
                cell.configureCell(perfume: perfume)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIPerfumeResultSection, HBTIPerfumeResultItem>()
        initialSnapshot.appendSections([.perfume])
        initialSnapshot.appendItems([.perfume(HBTIPerfume(id: 1, nameKR: "이름1", nameEN: "name1", price: 128000))])
        initialSnapshot.appendItems([.perfume(HBTIPerfume(id: 2, nameKR: "이름2", nameEN: "name2", price: 34000))])
        initialSnapshot.appendItems([.perfume(HBTIPerfume(id: 3, nameKR: "이름3", nameEN: "name3", price: 60000))])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}
