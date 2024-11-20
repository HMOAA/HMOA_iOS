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
        $0.setImage(UIImage(named: "noteClearButton"), for: .normal)
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
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(18)
        }
        
        selectedNoteCollectionView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(clearButton.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(20)
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
            section.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 16)
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
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func updateSnapshot(with notes: [String]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .selected))
        snapshot.appendItems(notes.map { .note($0) }, toSection: .selected)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func hideSelectedNoteCollectionView(isEmptySelectedNoteList: Bool) {
        self.selectedNoteCollectionView.isHidden = isEmptySelectedNoteList
        self.clearButton.isHidden = isEmptySelectedNoteList
    }
}
