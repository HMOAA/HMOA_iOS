//
//  HBTINoteQuestionCell.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/5/24.
//

import UIKit

import Then
import SnapKit
import RxSwift

class HBTINoteQuestionCell: UICollectionViewCell {
    
    static let identifier = "HBTINoteQuestionCell"
    
    // MARK: - UI Components
    
    private let selectLabel = UILabel().then {
        $0.setLabelUI("", font: .pretendard_bold, size: 20, color: .black)
        $0.setTextWithLineHeight(text: "선택안내", lineHeight: 27)
    }
    
    lazy var noteCategoryCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            HBTINoteCell.self,
            forCellWithReuseIdentifier: HBTINoteCell.identifier
        )
        $0.register(
            HBTINoteCategoryHeaderView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.header,
            withReuseIdentifier: HBTINoteCategoryHeaderView.identifier
        )
    }
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTINoteQuestionSection, HBTINoteQuestionItem>?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setAddView() {
        [
            selectLabel,
            noteCategoryCollectionView
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        selectLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        noteCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(60),
                heightDimension: .absolute(32)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(32)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 16, leading: 0, bottom: 24, trailing: 0)
            section.boundarySupplementaryItems = [headerItem]
            
            return section
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: noteCategoryCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HBTINoteCell.identifier,
                for: indexPath) as! HBTINoteCell
            
            cell.configureCell(item.note)
            
            return cell
            
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTINoteQuestionSection, HBTINoteQuestionItem>()
        
        let section1 = HBTINoteQuestionSection(category: "시험용")
        initialSnapshot.appendSections([section1])
        initialSnapshot.appendItems([.init(note: "시험1"), .init(note: "tlgja1")], toSection: section1)
        
        let section2 = HBTINoteQuestionSection(category: "시험용2")
        initialSnapshot.appendSections([section2])
        initialSnapshot.appendItems([.init(note: "시험2")], toSection: section2)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
        
        // MARK: Supplementary View Provider
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.header:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: SupplementaryViewKind.header,
                    withReuseIdentifier: HBTINoteCategoryHeaderView.identifier,
                    for: indexPath) as! HBTINoteCategoryHeaderView
                headerView.configureHeader("헤더")
                
                return headerView
                
            default:
                return nil
            }
        }
    }
    
    
    func configureCell(question: HBTINoteQuestion) {
        selectLabel.text = question.content
    }
    
}
