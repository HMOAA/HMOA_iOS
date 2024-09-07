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
    
    lazy var selectedNoteView = HBTISelectedNoteView()
    
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
        
        setUI()
        setAddView()
        setConstraints()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setUI() {
        noteCategoryCollectionView.showsVerticalScrollIndicator = false
    }
    
    private func setAddView() {
        [
            selectedNoteView,
            selectLabel,
            noteCategoryCollectionView
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        selectedNoteView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        selectLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedNoteView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        noteCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(52)
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
        
        let sections = [
            HBTINoteAnswer(category: "시험1", notes: ["노트1-1", "노트1-2"]),
            HBTINoteAnswer(category: "시험2", notes: ["노트2-1", "노트2-2"]),
            HBTINoteAnswer(category: "시험3", notes: ["노트3-1", "노트3-2"]),
            HBTINoteAnswer(category: "시험4", notes: ["노트4-1", "노트4-2"]),
            HBTINoteAnswer(category: "시험5", notes: ["노트5-1", "노트5-2"]),
            HBTINoteAnswer(category: "시험6", notes: ["노트6-1", "노트6-2"]),
            HBTINoteAnswer(category: "시험7", notes: ["노트7-1", "노트7-2"])
        ]
        
        for data in sections {
            let section = HBTINoteQuestionSection(category: data.category)
            initialSnapshot.appendSections([section])
            
            let items = data.notes.map { HBTINoteQuestionItem(note: $0)}
            initialSnapshot.appendItems(items, toSection: section)
        }
        
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
