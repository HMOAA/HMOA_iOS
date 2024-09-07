//
//  HBTISelectedNoteView.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 9/6/24.
//

import UIKit

import Then
import SnapKit

final class HBTISelectedNoteView: UIView {
    
    // MARK: - UI Components
    
    let clearButton = UIButton().then {
        $0.setImage(UIImage(named: "clearButton"), for: .normal)
    }
    
    lazy var selectedNoteCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createSelectedNoteLayout()
    ).then {
        $0.register(
            HBTISelectedNoteCell.self,
            forCellWithReuseIdentifier: HBTISelectedNoteCell.identifier
        )
    }
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTISelectedNoteSection, HBTISelectedNoteItem>?
    
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
        selectedNoteCollectionView.isScrollEnabled = false
    }
    
    private func setAddView() {
        [
            clearButton,
            selectedNoteCollectionView
        ].forEach { addSubview($0) }
    }
    
    private func setConstraints() {
        clearButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
            make.height.width.equalTo(18)
        }
        
        selectedNoteCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(clearButton.snp.trailing).offset(8)
            make.verticalEdges.trailing.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    private func createSelectedNoteLayout() ->UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(80),
                heightDimension: .absolute(32)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 8
            
            return section
            
        }
        return layout
    }
    
    // MARK: Configure DataSource
    private func configureDataSource() {
        dataSource = .init(collectionView: selectedNoteCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .note(let note):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTISelectedNoteCell.identifier,
                    for: indexPath) as! HBTISelectedNoteCell
                
                cell.configureCell(note)
                
                return cell
            }
            
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTISelectedNoteSection, HBTISelectedNoteItem>()
        initialSnapshot.appendSections([.selected])
        initialSnapshot.appendItems([.note("선택된 향료1"), .note("선택된 향료2"), .note("선택된 향료3"), .note("선택된 향료4")])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
}
