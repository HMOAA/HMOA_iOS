//
//  HBTIProductInfoView.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
//

import UIKit
import SnapKit
import Then

final class HBTIProductInfoView: UIView {
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<HBTIOrderSheetProductSection, HBTIOrderSheetProductItem>?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.setLabelUI("상품 정보", font: .pretendard_bold, size: 18, color: .black)
    }
    
    private lazy var productCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.register(
            HBTIProductInfoCell.self,
            forCellWithReuseIdentifier: HBTIProductInfoCell.reuseIdentifier
        )
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Initialization

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

    // MARK: - Set UI

    private func setUI() {
        
    }

    // MARK: - Set AddView

    private func setAddView() {
        [
         titleLabel,
         productCollectionView
        ].forEach(addSubview)
    }

    // MARK: - Set Constraints

    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        productCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: Create Layout
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(102)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(102)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // MARK: Configure DataSource
    
    private func configureDataSource() {
        dataSource = .init(collectionView: productCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch item {
            case .productInfo(let product):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HBTIProductInfoCell.reuseIdentifier,
                    for: indexPath) as! HBTIProductInfoCell
                let isSeparatorHidden = indexPath.row == (self.dataSource?.snapshot().itemIdentifiers.count ?? 1) - 1
                cell.configureCell(product: product, isSeparatorHidden: isSeparatorHidden)
                
                return cell
            }
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<HBTIOrderSheetProductSection, HBTIOrderSheetProductItem>()
        initialSnapshot.appendSections([.order])
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }
    
    private func updateCollectionViewHeight() {
        let cellHeight: CGFloat = 62
        let spacing: CGFloat = 40
        let numberOfItems = dataSource?.snapshot().itemIdentifiers.count ?? 0

        // 총 높이 = (셀 높이 * 셀 개수) + (간격 * (셀 개수))
        let totalHeight = CGFloat(numberOfItems) * cellHeight + CGFloat(numberOfItems) * spacing
        
        productCollectionView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
            $0.bottom.equalToSuperview()
        }
    }

    func updateSnapshot(forSection section: HBTIOrderSheetProductSection, withItems items: [HBTIOrderSheetProductItem]) {
        guard let dataSource = self.dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }
}
